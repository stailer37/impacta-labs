FROM --platform=linux/amd64 bde2020/hadoop-base:2.0.0-hadoop3.2.1-java8

ENV SQOOP_VERSION=1.4.7
ENV SQOOP_HOME=/opt/sqoop
ENV HADOOP_HOME=/opt/hadoop-3.2.1
ENV PATH=${SQOOP_HOME}/bin:${HADOOP_HOME}/bin:${PATH}

RUN apt-get update && apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# Instala o Sqoop 1.4.7
RUN curl -fsSL \
    "https://archive.apache.org/dist/sqoop/${SQOOP_VERSION}/sqoop-${SQOOP_VERSION}.bin__hadoop-2.6.0.tar.gz" \
    -o /tmp/sqoop.tar.gz && \
    tar -xzf /tmp/sqoop.tar.gz -C /opt/ && \
    mv /opt/sqoop-${SQOOP_VERSION}.bin__hadoop-2.6.0 ${SQOOP_HOME} && \
    rm /tmp/sqoop.tar.gz

# MySQL JDBC Connector
RUN curl -fsSL \
    "https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar" \
    -o ${SQOOP_HOME}/lib/mysql-connector-java-8.0.28.jar

# PostgreSQL JDBC Connector
RUN curl -fsSL \
    "https://repo1.maven.org/maven2/org/postgresql/postgresql/42.5.0/postgresql-42.5.0.jar" \
    -o ${SQOOP_HOME}/lib/postgresql-42.5.0.jar

# commons-lang 2.6 (necessário para compatibilidade Sqoop 1.4.7 com Hadoop 3.x)
RUN curl -fsSL \
    "https://repo1.maven.org/maven2/commons-lang/commons-lang/2.6/commons-lang-2.6.jar" \
    -o ${SQOOP_HOME}/lib/commons-lang-2.6.jar

# Copia commons-lang3 do Hadoop para o Sqoop (também necessário no Hadoop 3.x)
RUN cp ${HADOOP_HOME}/share/hadoop/common/lib/commons-lang3-*.jar ${SQOOP_HOME}/lib/ 2>/dev/null || true

CMD ["tail", "-f", "/dev/null"]
