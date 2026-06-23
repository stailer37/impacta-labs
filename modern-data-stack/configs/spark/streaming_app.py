"""
Pipeline de streaming com Spark Structured Streaming.

Visão geral do fluxo (ETL contínuo):
1. LER: consome eventos de transações de PDV (ponto de venda) em tempo real
   de um tópico Kafka.
2. TRANSFORMAR: converte o JSON bruto de cada mensagem em colunas tipadas
   (schema) e adiciona um timestamp de quando o dado chegou ao pipeline.
3. ESCREVER: grava o resultado de forma incremental em uma tabela Iceberg,
   que é um formato de tabela "data lakehouse" (combina a flexibilidade de
   um data lake com recursos de um banco de dados, como schema e ACID).

Esse padrão é conhecido como streaming ETL: ao contrário de um job batch
(que roda uma vez e processa um lote de dados), aqui o Spark fica
continuamente "escutando" novos eventos e processando-os em micro-lotes.
"""

import os

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, current_timestamp, from_json
from pyspark.sql.types import (
    DoubleType,
    IntegerType,
    StringType,
    StructField,
    StructType,
    TimestampType,
)

# Nomes lógicos usados para localizar a tabela de destino dentro do catálogo
# Iceberg: catalog.namespace.table (equivalente a database.schema.table em
# bancos relacionais tradicionais).
CATALOG = "raw"
WAREHOUSE = "raw"
NAMESPACE = "streaming"
TABLE = "pos_transactions"

# Configurações de conexão lidas de variáveis de ambiente. Usar variáveis de
# ambiente (em vez de "hardcodar" valores no código) é uma boa prática:
# permite rodar o mesmo código em diferentes ambientes (dev, teste, produção)
# apenas trocando a configuração, sem alterar uma linha de código.
CATALOG_URL = os.environ.get("LAKEKEEPER_CATALOG_URL", "http://lakekeeper:8181/catalog")
MINIO_ENDPOINT = os.environ.get("MINIO_ENDPOINT", "http://minio:9000")  # MinIO simula um storage S3 localmente
MINIO_ACCESS_KEY = os.environ["AWS_ACCESS_KEY_ID"]
MINIO_SECRET_KEY = os.environ["AWS_SECRET_ACCESS_KEY"]
KAFKA_BOOTSTRAP_SERVERS = os.environ.get("KAFKA_BOOTSTRAP_SERVERS", "kafka:9092")
KAFKA_TOPIC = os.environ.get("KAFKA_TOPIC", "pos_transactions")
# O checkpoint é onde o Spark guarda o "progresso" do streaming (quais
# mensagens já foram processadas). Isso garante que, se o job cair e for
# reiniciado, ele continue de onde parou em vez de reprocessar tudo ou
# perder dados (tolerância a falhas).
CHECKPOINT_LOCATION = os.environ.get(
    "CHECKPOINT_LOCATION", "s3a://raw/_checkpoints/pos_transactions"
)

# Schema esperado de cada evento de transação que chega via Kafka.
# Definir o schema explicitamente (em vez de deixar o Spark "adivinhar")
# evita erros silenciosos e deixa claro o contrato de dados esperado.
# O segundo argumento de cada StructField indica se o campo aceita nulo
# (True = aceita nulo, False = obrigatório).
POS_TRANSACTION_SCHEMA = StructType(
    [
        StructField("transaction_id", StringType(), False),
        StructField("event_timestamp", StringType(), False),
        StructField("store_id", StringType(), False),
        StructField("register_id", IntegerType(), False),
        StructField("employee_id", IntegerType(), False),
        StructField("customer_id", IntegerType(), True),
        StructField("product_id", IntegerType(), False),
        StructField("quantity", IntegerType(), False),
        StructField("unit_price", DoubleType(), False),
        StructField("discount", DoubleType(), False),
        StructField("payment_method", StringType(), False),
    ]
)

# A SparkSession é o "ponto de entrada" para qualquer aplicação Spark: é
# através dela que registramos catálogos, executamos SQL e criamos
# DataFrames. Aqui ela é configurada para conhecer dois sistemas externos:
#   - o catálogo Iceberg (Lakekeeper), que guarda metadados das tabelas;
#   - o storage S3-compatível (MinIO), onde os arquivos de dados ficam.
spark = (
    SparkSession.builder.appName("PosTransactionsStreaming")
    .config(f"spark.sql.catalog.{CATALOG}", "org.apache.iceberg.spark.SparkCatalog")
    .config(f"spark.sql.catalog.{CATALOG}.type", "rest")
    .config(f"spark.sql.catalog.{CATALOG}.uri", CATALOG_URL)
    .config(f"spark.sql.catalog.{CATALOG}.warehouse", WAREHOUSE)
    .config("spark.sql.extensions", "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions")
    .config("spark.hadoop.fs.s3a.endpoint", MINIO_ENDPOINT)
    .config("spark.hadoop.fs.s3a.access.key", MINIO_ACCESS_KEY)
    .config("spark.hadoop.fs.s3a.secret.key", MINIO_SECRET_KEY)
    .config("spark.hadoop.fs.s3a.path.style.access", "true")
    .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
    .config("spark.hadoop.fs.s3a.connection.ssl.enabled", "false")
    .config("spark.sql.shuffle.partitions", "4")  # poucas partições pois é um ambiente de laboratório/baixo volume
    .getOrCreate()
)
spark.sparkContext.setLogLevel("WARN")  # reduz o volume de logs, mostrando só avisos e erros

# Garante que o namespace (schema) e a tabela de destino existam antes do
# streaming começar a escrever. "IF NOT EXISTS" torna o script idempotente:
# pode ser executado várias vezes sem quebrar caso os objetos já existam.
spark.sql(f"CREATE SCHEMA IF NOT EXISTS {CATALOG}.{NAMESPACE}")
spark.sql(
    f"""
    CREATE TABLE IF NOT EXISTS {CATALOG}.{NAMESPACE}.{TABLE} (
        transaction_id STRING,
        event_timestamp TIMESTAMP,
        store_id STRING,
        register_id INT,
        employee_id INT,
        customer_id INT,
        product_id INT,
        quantity INT,
        unit_price DOUBLE,
        discount DOUBLE,
        payment_method STRING,
        ingestion_timestamp TIMESTAMP
    )
    USING iceberg
    """
)

# ETAPA 1 - LEITURA (Extract)
# readStream cria um DataFrame "infinito": ele não lê os dados de uma vez,
# mas representa um fluxo contínuo de novas mensagens do tópico Kafka.
# "startingOffsets: earliest" diz para começar lendo desde a mensagem mais
# antiga disponível no tópico (útil em laboratório/testes; em produção é
# comum usar "latest" para processar só o que chegar a partir de agora).
kafka_df = (
    spark.readStream.format("kafka")
    .option("kafka.bootstrap.servers", KAFKA_BOOTSTRAP_SERVERS)
    .option("subscribe", KAFKA_TOPIC)
    .option("startingOffsets", "earliest")
    .option("failOnDataLoss", "false")
    .load()
)

# ETAPA 2 - TRANSFORMAÇÃO (Transform)
# Cada mensagem do Kafka chega como bytes brutos na coluna "value". Aqui:
#   1. Convertemos esses bytes para string (texto JSON);
#   2. Usamos from_json + o schema definido acima para "abrir" o JSON em
#      colunas estruturadas (ex.: transaction_id, store_id, etc.);
#   3. select("data.*") "achata" a estrutura aninhada, trazendo cada campo
#      do JSON para uma coluna no nível principal do DataFrame.
parsed_df = kafka_df.select(
    from_json(col("value").cast("string"), POS_TRANSACTION_SCHEMA).alias("data")
).select("data.*")

# Ajustes finais antes de gravar:
#   - event_timestamp chega como texto (STRING) e é convertido para o tipo
#     TIMESTAMP, para permitir consultas e ordenações temporais corretas;
#   - ingestion_timestamp registra o momento em que o Spark processou o
#     evento, útil para auditoria e para medir a latência entre o evento
#     acontecer na loja e ele chegar ao lakehouse.
transformed_df = parsed_df.withColumn(
    "event_timestamp", col("event_timestamp").cast(TimestampType())
).withColumn("ingestion_timestamp", current_timestamp())

# ETAPA 3 - ESCRITA (Load)
# writeStream inicia o processamento contínuo. Principais pontos:
#   - outputMode("append"): cada novo evento processado é apenas
#     adicionado à tabela (não há atualização/remoção de linhas existentes);
#   - trigger(processingTime="10 seconds"): em vez de gravar evento a
#     evento (caro e ineficiente), o Spark agrupa os eventos chegados a
#     cada 10 segundos em um "micro-lote" e grava de uma vez;
#   - checkpointLocation: local onde o Spark salva o progresso da leitura,
#     garantindo que, após uma falha e reinício, o job retome exatamente
#     de onde parou (exactly-once / tolerância a falhas).
query = (
    transformed_df.writeStream.format("iceberg")
    .outputMode("append")
    .trigger(processingTime="10 seconds")
    .option("fanout-enabled", "true")
    .option("checkpointLocation", CHECKPOINT_LOCATION)
    .toTable(f"{CATALOG}.{NAMESPACE}.{TABLE}")
)

# Mantém o processo em execução, processando micro-lotes indefinidamente,
# até que o job seja interrompido manualmente (ex.: Ctrl+C ou parada do
# container).
query.awaitTermination()
