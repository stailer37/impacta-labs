#!/bin/bash
if [ ! -f ./configs/nifi/nifi-hadoop-libraries-nar-2.4.0.nar ]; then
    curl -o ./configs/nifi/nifi-hadoop-libraries-nar-2.4.0.nar https://archive.apache.org/dist/nifi/2.4.0/nifi-hadoop-libraries-nar-2.4.0.nar
    if [ $? -ne 0 ]; then
        echo "Failed to download nifi-hadoop-libraries-nar-2.4.0.nar"
        exit 1
    fi
else
    echo "nifi-hadoop-libraries-nar-2.4.0.nar already exists, skipping download."
fi

if [ ! -f ./configs/nifi/nifi-parquet-nar-2.4.0.nar ]; then
    curl -o ./configs/nifi/nifi-parquet-nar-2.4.0.nar https://archive.apache.org/dist/nifi/2.4.0/nifi-parquet-nar-2.4.0.nar
    if [ $? -ne 0 ]; then
        echo "Failed to download nifi-parquet-nar-2.4.0.nar"
        exit 1
    fi
else
    echo "nifi-parquet-nar-2.4.0.nar already exists, skipping download."
fi
echo "Checked required NAR files."

if [ ! -f ./configs/nifi/postgresql-42.7.5.jar ]; then
    curl -o ./configs/nifi/postgresql-42.7.5.jar https://jdbc.postgresql.org/download/postgresql-42.7.5.jar
    if [ $? -ne 0 ]; then
        echo "Failed to download postgresql-42.7.5.jar"
        exit 1
    fi
else
    echo "postgresql-42.7.5.jar already exists, skipping download."
fi
echo "Checked PostgreSQL JDBC driver."

if [ ! -f ./configs/pagila/pagila-schema.sql ]; then
    curl -o ./configs/pagila/pagila-schema.sql https://raw.githubusercontent.com/devrimgunduz/pagila/refs/heads/master/pagila-schema.sql
    if [ $? -ne 0 ]; then
        echo "Failed to download pagila-schema.sql"
        exit 1
    fi
else
    echo "pagila-schema.sql already exists, skipping download."
fi
echo "Checked Pagila database schema."

if [ ! -f ./configs/pagila/pagila-data.sql ]; then
    curl -o ./configs/pagila/pagila-data.sql https://raw.githubusercontent.com/devrimgunduz/pagila/refs/heads/master/pagila-data.sql
    if [ $? -ne 0 ]; then
        echo "Failed to download pagila-data.sql"
        exit 1
    fi
else
    echo "pagila-data.sql already exists, skipping download."
fi
echo "Checked Pagila database data."

docker compose -f docker-compose.yml up -d
echo "Modern Data Stack is starting up..."