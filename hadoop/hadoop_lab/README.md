# Hadoop Lab — HDFS + MapReduce + Spark com Docker

Este laboratório sobe um mini cluster Hadoop completo no seu computador, usando Docker, para você experimentar na prática os conceitos vistos em aula: armazenamento distribuído (HDFS), processamento distribuído (MapReduce e Spark) e catálogo de metadados (Hive Metastore).

A ideia não é decorar comandos, e sim **entender o que acontece por trás de cada um** — por isso cada seção abaixo começa com o conceito antes do comando.

## O que você vai praticar

1. Subir um cluster Hadoop com múltiplos nós usando Docker Compose.
2. Gravar e ler arquivos no HDFS e ver como ele replica os dados entre nós.
3. Rodar um job MapReduce clássico (contagem de palavras) e acompanhar sua execução no YARN.
4. Rodar um job de ETL em Spark que lê de um banco relacional (MySQL), grava em Parquet no HDFS e registra a tabela no Hive Metastore.

## Arquitetura do cluster

As imagens usadas são as oficiais [apache/hadoop](https://hub.docker.com/r/apache/hadoop), [apache/hive](https://hub.docker.com/r/apache/hive) e [apache/spark-py](https://hub.docker.com/r/apache/spark-py). Cada serviço roda em um container separado, simulando máquinas diferentes de um cluster real:

| Camada | Serviços | Para que serve |
|---|---|---|
| **HDFS** (armazenamento) | 1 NameNode + 3 DataNodes | Sistema de arquivos distribuído. O NameNode guarda os metadados (onde está cada arquivo); os DataNodes guardam os blocos de dados de fato. Fator de replicação 3 = cada bloco fica copiado em 3 nós diferentes, para tolerar falhas. |
| **YARN** (orquestração) | ResourceManager + NodeManager + JobHistory Server | Gerenciador de recursos do cluster: decide onde cada job roda e acompanha sua execução. O JobHistory guarda o histórico de jobs concluídos. |
| **Hive Metastore** | Metastore + Postgres | Catálogo central de tabelas (nome, colunas, schema, localização no HDFS). Tanto o Hive quanto o Spark consultam esse catálogo para saber "o que é a tabela X e onde ela está". |
| **Spark** (processamento) | Spark Master + Spark Worker | Motor de processamento distribuído, usado aqui para rodar um ETL: MySQL → Parquet no HDFS → tabela no Hive. |
| **MySQL** | 1 instância | Simula um banco transacional de origem (ex.: o banco de um sistema de RH), de onde o ETL extrai os dados. |

```
        ┌──────────┐        ┌────────────────────┐
        │  MySQL   │──JDBC──▶│   Spark (ETL job)  │
        └──────────┘        └─────────┬──────────┘
                                       │ grava Parquet
                                       ▼
┌─────────────┐   replica   ┌──────────────────┐
│  NameNode   │◀───────────▶│  DataNode 1/2/3   │   ← HDFS
└─────────────┘             └──────────────────┘
        ▲
        │ registra schema/local.
        ▼
┌──────────────────┐
│  Hive Metastore   │   ← catálogo consultado pelo Spark
└──────────────────┘

┌──────────────────┐    agenda/acompanha jobs    ┌──────────────┐
│ ResourceManager   │◀───────────────────────────▶│ NodeManager  │  ← YARN
└──────────────────┘                              └──────────────┘
```

## Pré-requisitos

- Docker e Docker Compose instalados.
- Portas livres na sua máquina: `9870`, `8020`, `8088`, `19888`, `8080`, `8081`, `3306`, `9083`.

## 1. Subir o ambiente

```bash
cd hadoop/hadoop_lab
docker compose up -d
```

Isso vai construir as imagens necessárias e iniciar todos os containers em segundo plano. Na primeira vez, pode demorar alguns minutos (download das imagens + build do Spark).

**Por que esperar o NameNode ficar "healthy"?** Quando o HDFS sobe pela primeira vez, o NameNode entra em *safe mode*: um estado de só-leitura em que ele ainda está verificando se já recebeu relatórios de blocos suficientes dos DataNodes. Os DataNodes só conseguem se registrar depois que o NameNode está pronto — por isso o `docker-compose.yml` faz os DataNodes esperarem o `healthcheck` do NameNode (`depends_on: condition: service_healthy`).

Acompanhe a inicialização com:

```bash
docker compose ps
```

Espere todos os serviços (em especial `namenode`) aparecerem como `healthy` antes de seguir para os testes.

## 2. Acessar as interfaces web

Cada serviço expõe uma UI onde dá para acompanhar visualmente o que está acontecendo — vale a pena deixar aberta enquanto roda os exercícios:

| Interface | URL | O que observar |
|---|---|---|
| NameNode Web UI | http://localhost:9870 | Aba "Datanodes" → confirme que os 3 DataNodes estão ativos (`In Service`) |
| ResourceManager Web UI | http://localhost:8088 | Aplicações em execução/concluídas e NodeManagers registrados |
| JobHistory Web UI | http://localhost:19888 | Detalhes de jobs MapReduce já concluídos (contadores, tempo de execução) |
| Spark Master Web UI | http://localhost:8080 | Workers conectados e aplicações Spark em execução |
| Spark Worker Web UI | http://localhost:8081 | Recursos (CPU/memória) do worker e executors rodando |

Outros acessos úteis (via linha de comando, não browser):

- HDFS RPC (cliente fora do container): `hdfs://localhost:8020`
- MySQL: `localhost:3306`, database `impacta`, usuário `root` / senha `root123`
- Hive Metastore (Thrift): `thrift://localhost:9083`

## 3. Testar o HDFS: gravando e lendo arquivos distribuídos

**Conceito:** no HDFS, um arquivo é dividido em blocos e cada bloco é replicado em vários nós (aqui, fator de replicação 3). Isso significa que mesmo que um DataNode caia, o arquivo continua acessível pelos outros dois.

```bash
# cria um diretório no HDFS (assim como mkdir, mas no sistema de arquivos distribuído)
docker exec namenode hdfs dfs -mkdir -p /user/aluno

# grava um arquivo de teste
echo "hello hdfs" | docker exec -i namenode hdfs dfs -put - /user/aluno/teste.txt

# lê o arquivo de volta
docker exec namenode hdfs dfs -cat /user/aluno/teste.txt

# inspeciona onde os blocos desse arquivo foram parar
docker exec namenode hdfs fsck /user/aluno/teste.txt -files -blocks -locations
```

**O que observar no `fsck`:** a saída deve mostrar `Live_repl=3`, com os blocos distribuídos entre `datanode1`, `datanode2` e `datanode3` — prova de que a replicação está funcionando.

## 4. Testar o MapReduce: contagem de palavras (word count)

**Conceito:** o MapReduce processa dados em duas fases. A fase *Map* lê os dados de entrada e emite pares `(palavra, 1)` para cada ocorrência; a fase *Reduce* agrupa esses pares por palavra e soma as ocorrências. O YARN é quem decide em qual nó cada tarefa de map/reduce roda.

```bash
docker exec namenode sh -c "
  hdfs dfs -mkdir -p /user/aluno/wordcount/input
  echo 'hadoop mapreduce hdfs yarn hadoop yarn hadoop' | hdfs dfs -put - /user/aluno/wordcount/input/text.txt
  hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.4.2.jar wordcount /user/aluno/wordcount/input /user/aluno/wordcount/output
"
docker exec namenode hdfs dfs -cat /user/aluno/wordcount/output/part-r-00000
```

O resultado esperado é a contagem de cada palavra do texto de entrada (ex.: `hadoop` aparecendo 3 vezes, `yarn` 2 vezes, etc.).

Enquanto o job roda, acompanhe em http://localhost:8088 (aplicação em andamento); depois de concluído, os detalhes ficam disponíveis em http://localhost:19888.

## 5. Testar o Spark: ETL MySQL → HDFS (Parquet) → Hive

**Conceito:** este é um pipeline de ETL típico de engenharia de dados — extrai de um banco transacional, transforma/grava em um formato colunar otimizado para analytics (Parquet) e registra a tabela em um catálogo (Hive Metastore) para que outras ferramentas (Spark SQL, BI, etc.) consigam consultá-la sem precisar saber onde o arquivo físico está.

O MySQL já sobe com uma base `impacta` e uma tabela `employees` de exemplo (veja [mysql/init.sql](mysql/init.sql)). O job [spark/jobs/etl_employees.py](spark/jobs/etl_employees.py) lê essa tabela via JDBC, grava o resultado em Parquet no HDFS e registra a tabela `impacta.employees` no Hive Metastore (`saveAsTable`).

Submeta o job ao cluster Spark:

```bash
docker exec spark-master /opt/spark/bin/spark-submit \
  --master spark://spark-master:7077 \
  /opt/spark/work-dir/jobs/etl_employees.py
```

Agora confira o resultado em cada camada do pipeline:

```bash
# 1) O arquivo Parquet foi realmente gravado no HDFS?
docker exec namenode hdfs dfs -ls /user/hive/warehouse/impacta.db/employees

# 2) A tabela foi registrada no catálogo do Hive Metastore?
docker exec hive-metastore-db psql -U hive -d metastore -c \
  "SELECT d.\"NAME\" AS db, t.\"TBL_NAME\" AS table, s.\"LOCATION\" FROM \"TBLS\" t JOIN \"DBS\" d ON t.\"DB_ID\"=d.\"DB_ID\" JOIN \"SDS\" s ON t.\"SD_ID\"=s.\"SD_ID\";"

# 3) Dá para consultar a tabela direto pelo Spark, sem tocar no MySQL de novo?
docker exec spark-master /opt/spark/bin/spark-sql --master spark://spark-master:7077 \
  -e "SELECT * FROM impacta.employees LIMIT 5;"
```

O passo 3 é o que demonstra a utilidade do catálogo: o Spark SQL encontrou a tabela `impacta.employees` só pelo nome, sem você precisar informar o caminho do Parquet no HDFS — essa informação já estava no Hive Metastore.

Acompanhe a execução em http://localhost:8080 (Spark Master).

## Configuração (para quem quiser ir além)

Esta seção é opcional — explica como o cluster é montado por baixo dos panos, caso você queira customizar algo.

- As propriedades de `core-site.xml`, `hdfs-site.xml`, `mapred-site.xml` e `yarn-site.xml` são geradas a partir do [hadoop.env](hadoop.env) pelo próprio entrypoint da imagem (`envtoconf.py`), seguindo o padrão `PREFIXO-SITE.XML_propriedade=valor` (ex.: `YARN-SITE.XML_yarn.resourcemanager.hostname=resourcemanager`).

  > O `$$HADOOP_HOME` em `MAPRED-SITE.XML_*.env` está escapado com `$$` de propósito: o Docker Compose interpola `env_file` antes de repassar as variáveis ao container, então `$$` vira `$HADOOP_HOME` literal — que é resolvido depois pelo próprio YARN ao lançar os containers de map/reduce.

- Os dados de cada nó são persistidos em volumes Docker nomeados, montados em `/data` dentro do container (o NameNode formata o diretório automaticamente na primeira subida, via `ENSURE_NAMENODE_DIR`).

- O **Hive Metastore** (imagem [apache/hive:3.1.3](https://hub.docker.com/r/apache/hive)) usa Postgres como backend e é configurado via [hive/conf/hive-site.xml](hive/conf/hive-site.xml) (montado como `HIVE_CUSTOM_CONF_DIR`). O entrypoint padrão da imagem tenta rodar `schematool -initSchema` toda vez que sobe — em uma reinicialização normal isso quebraria o container, pois o schema já existe. Por isso o serviço usa um wrapper, [hive/init-metastore.sh](hive/init-metastore.sh), que só inicializa o schema na primeira subida (verificando antes com `schematool -info`) e nas demais delega para o entrypoint original com `IS_RESUME=true`.

- O **Spark** (imagem [apache/spark-py:v3.4.0](https://hub.docker.com/r/apache/spark-py)) é estendido em [spark/Dockerfile](spark/Dockerfile) com o driver JDBC do MySQL e a configuração do Hive (`hive-site.xml` apontando para `thrift://hive-metastore:9083` e `spark-defaults.conf` com `spark.sql.warehouse.dir=hdfs://namenode:8020/user/hive/warehouse`), para que qualquer `spark-submit`/`spark-sql` já saia integrado ao cluster sem flags extras.

## Solução de problemas comuns

- **`docker compose ps` mostra `namenode` sem ficar `healthy`**: aguarde — o `healthcheck` tem `start_period: 40s` e até 30 tentativas a cada 10s. Se passar de ~5 minutos, veja os logs com `docker compose logs namenode`.
- **Comando do HDFS trava ou dá timeout**: confirme que o `namenode` está `healthy` antes de rodar qualquer comando `hdfs dfs`.
- **`spark-submit` falha ao conectar no Hive Metastore ou no MySQL**: confira se `hive-metastore` e `mysql` já estão de pé (`docker compose ps`) — o `spark-master` depende deles, mas se algo demorou para subir, tente rodar o job de novo.

## Parar o ambiente

```bash
docker compose down       # mantém os volumes (dados persistem)
docker compose down -v    # remove também os volumes (reset completo)
```
