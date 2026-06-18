#!/bin/bash
# Wrapper em torno do entrypoint padrão da imagem apache/hive: só roda o
# "schematool -initSchema" se o schema ainda não existir no Postgres,
# evitando crash-loop em reinicializações do container (o entrypoint
# original tenta inicializar o schema sempre que IS_RESUME=false).
set -e

export HIVE_CONF_DIR="${HIVE_HOME}/conf"
if [ -d "${HIVE_CUSTOM_CONF_DIR:-}" ]; then
  find "${HIVE_CUSTOM_CONF_DIR}" -type f -exec ln -sfn {} "${HIVE_CONF_DIR}"/ \;
  export HADOOP_CONF_DIR="${HIVE_CONF_DIR}"
fi

if /opt/hive/bin/schematool -dbType postgres -info > /tmp/schema-check.log 2>&1; then
  echo "Schema do Hive Metastore já existe, pulando initSchema."
else
  echo "Inicializando schema do Hive Metastore..."
  /opt/hive/bin/schematool -dbType postgres -initSchema
fi

export IS_RESUME=true
exec /entrypoint.sh
