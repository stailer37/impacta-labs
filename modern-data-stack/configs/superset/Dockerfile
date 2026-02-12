FROM apache/superset:latest

USER root

RUN apt-get install curl -y
COPY --chmod=777 superset_config.py /app/
ENV SUPERSET_CONFIG_PATH /app/superset_config.py

RUN uv pip install trino sqlalchemy-trino psycopg2-binary

USER superset
ENTRYPOINT [ "/usr/bin/run-server.sh" ]