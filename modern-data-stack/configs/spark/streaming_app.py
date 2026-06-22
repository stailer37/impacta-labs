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

CATALOG = "raw"
WAREHOUSE = "raw"
NAMESPACE = "streaming"
TABLE = "pos_transactions"

CATALOG_URL = os.environ.get("LAKEKEEPER_CATALOG_URL", "http://lakekeeper:8181/catalog")
MINIO_ENDPOINT = os.environ.get("MINIO_ENDPOINT", "http://minio:9000")
MINIO_ACCESS_KEY = os.environ["AWS_ACCESS_KEY_ID"]
MINIO_SECRET_KEY = os.environ["AWS_SECRET_ACCESS_KEY"]
KAFKA_BOOTSTRAP_SERVERS = os.environ.get("KAFKA_BOOTSTRAP_SERVERS", "kafka:9092")
KAFKA_TOPIC = os.environ.get("KAFKA_TOPIC", "pos_transactions")
CHECKPOINT_LOCATION = os.environ.get(
    "CHECKPOINT_LOCATION", "s3a://raw/_checkpoints/pos_transactions"
)

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
    .config("spark.sql.shuffle.partitions", "4")
    .getOrCreate()
)
spark.sparkContext.setLogLevel("WARN")

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

kafka_df = (
    spark.readStream.format("kafka")
    .option("kafka.bootstrap.servers", KAFKA_BOOTSTRAP_SERVERS)
    .option("subscribe", KAFKA_TOPIC)
    .option("startingOffsets", "earliest")
    .option("failOnDataLoss", "false")
    .load()
)

parsed_df = kafka_df.select(
    from_json(col("value").cast("string"), POS_TRANSACTION_SCHEMA).alias("data")
).select("data.*")

transformed_df = parsed_df.withColumn(
    "event_timestamp", col("event_timestamp").cast(TimestampType())
).withColumn("ingestion_timestamp", current_timestamp())

query = (
    transformed_df.writeStream.format("iceberg")
    .outputMode("append")
    .trigger(processingTime="10 seconds")
    .option("fanout-enabled", "true")
    .option("checkpointLocation", CHECKPOINT_LOCATION)
    .toTable(f"{CATALOG}.{NAMESPACE}.{TABLE}")
)

query.awaitTermination()
