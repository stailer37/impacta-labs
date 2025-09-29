#!/bin/bash
curl -o ./configs/nifi/nifi-hadoop-libraries-nar-2.4.0.nar https://archive.apache.org/dist/nifi/2.4.0/nifi-hadoop-libraries-nar-2.4.0.nar
if [ $? -ne 0 ]; then
    echo "Failed to download nifi-hadoop-libraries-nar-2.4.0.nar"
    exit 1
fi
curl -o ./configs/nifi/nifi-parquet-nar-2.4.0.nar https://archive.apache.org/dist/nifi/2.4.0/nifi-parquet-nar-2.4.0.nar
if [ $? -ne 0 ]; then
    echo "Failed to download nifi-parquet-nar-2.4.0.nar"
    exit 1
fi
echo "Downloaded required NAR files successfully."

curl -o ./configs/nifi/postgresql-42.7.5.jar https://jdbc.postgresql.org/download/postgresql-42.7.5.jar
if [ $? -ne 0 ]; then
    echo "Failed to download postgresql-42.7.5.jar"
    exit 1
fi
echo "Downloaded PostgreSQL JDBC driver successfully."

docker compose -f docker-compose.yml up -d
echo "Modern Data Stack is starting up..."