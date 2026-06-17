FROM apache/spark-py:v3.4.0

USER root

# Driver JDBC do MySQL, usado pelo job de ETL para ler a base de origem
RUN curl -fsSL \
    "https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.3.0/mysql-connector-j-8.3.0.jar" \
    -o /opt/spark/jars/mysql-connector-j-8.3.0.jar

COPY jobs/ /opt/spark/work-dir/jobs/
COPY conf/hive-site.xml /opt/spark/conf/hive-site.xml
COPY conf/spark-defaults.conf /opt/spark/conf/spark-defaults.conf

# A imagem roda com um UID arbitrário (grupo root); o worker standalone
# precisa criar/escrever em $SPARK_HOME/work e nos logs de evento.
RUN mkdir -p /opt/spark/work /opt/spark/logs && chmod -R g+rwX /opt/spark/work /opt/spark/logs

USER 185
