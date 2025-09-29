#!/bin/bash
set -e

# Inicializa o banco
superset db upgrade

# Cria o admin (ignora se já existir)
superset fab create-admin \
  --username admin \
  --firstname Admin \
  --lastname User \
  --email admin@localhost \
  --password impacta2025 \
  || true

# Inicializa roles e permissões
superset init

# Inicia o superset
superset run -h 0.0.0.0 -p 8088