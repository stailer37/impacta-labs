#!/bin/bash
# Wrapper em torno do entrypoint padrão da imagem apache/hive: garante que o
# diretório de scratch local (/tmp/hive, no filesystem do próprio container)
# e os diretórios no HDFS (/tmp/hive, /user/hive/warehouse) existem com
# permissão de escrita (777) antes de subir o HiveServer2.
#
# Sem isso, o HiveServer2 fica em loop de retry a cada 60s com
# "The dir: /tmp/hive on HDFS should be writable" — na prática a checagem é
# sobre o /tmp/hive LOCAL (criado pela própria JVM com o umask padrão, 755),
# não o do HDFS, mas corrigimos os dois por segurança: o local porque é onde
# o erro realmente ocorre, o do HDFS porque é onde o warehouse de fato grava.
set -e

export HIVE_CONF_DIR="${HIVE_HOME}/conf"
if [ -d "${HIVE_CUSTOM_CONF_DIR:-}" ]; then
  find "${HIVE_CUSTOM_CONF_DIR}" -type f -exec ln -sfn {} "${HIVE_CONF_DIR}"/ \;
  export HADOOP_CONF_DIR="${HIVE_CONF_DIR}"
fi

mkdir -p /tmp/hive
chmod 777 /tmp/hive

# Usa o HADOOP_CONF_DIR padrão da imagem (com core-site.xml válido, ainda que
# vazio) em vez do HIVE_CONF_DIR acima (só tem hive-site.xml) — sem isso o
# `hdfs dfs -fs ...` falha com "core-site.xml not found", mesmo passando a URI
# explicitamente.
HDFS_URI="hdfs://namenode:8020"
for dir in /tmp/hive /user/hive/warehouse; do
  HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop /opt/hadoop/bin/hdfs dfs -fs "${HDFS_URI}" -mkdir -p "${dir}"
  HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop /opt/hadoop/bin/hdfs dfs -fs "${HDFS_URI}" -chmod 777 "${dir}"
done

exec /entrypoint.sh
