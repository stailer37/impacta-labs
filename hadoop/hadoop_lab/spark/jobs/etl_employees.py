"""ETL: extrai employees do MySQL, grava em Parquet no HDFS e registra a
tabela no Hive Metastore (catálogo usado pelo Spark e por outras
ferramentas do ecossistema, como o Hive)."""

from pyspark.sql import SparkSession

MYSQL_URL = "jdbc:mysql://mysql:3306/impacta?useUnicode=true&characterEncoding=UTF-8"
MYSQL_PROPS = {
    "user": "spark",
    "password": "spark123",
    "driver": "com.mysql.cj.jdbc.Driver",
}


def main():
    spark = SparkSession.builder.appName("mysql-to-hdfs-parquet").enableHiveSupport().getOrCreate()

    df = spark.read.jdbc(url=MYSQL_URL, table="employees", properties=MYSQL_PROPS)
    print(f"Lidos {df.count()} registros de 'employees' no MySQL")
    df.printSchema()

    spark.sql("CREATE DATABASE IF NOT EXISTS impacta")
    df.write.mode("overwrite").format("parquet").saveAsTable("impacta.employees")
    print("Tabela impacta.employees gravada em Parquet no HDFS e registrada no Hive Metastore")

    spark.sql(
        "SELECT department, COUNT(*) AS total, ROUND(AVG(salary), 2) AS avg_salary "
        "FROM impacta.employees GROUP BY department ORDER BY department"
    ).show()

    spark.stop()


if __name__ == "__main__":
    main()
