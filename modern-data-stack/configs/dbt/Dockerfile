FROM python:3.12-slim

RUN pip install --no-cache-dir dbt-trino

WORKDIR /usr/app
ENTRYPOINT [ "dbt" ]
