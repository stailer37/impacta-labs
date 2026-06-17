#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

banner() {
  echo -e "${GREEN}"
  echo "╔══════════════════════════════════════════════════════╗"
  echo "║         Impacta Labs — Hadoop Ecosystem              ║"
  echo "║  HDFS · MapReduce · Hive · Sqoop · Hue              ║"
  echo "╚══════════════════════════════════════════════════════╝"
  echo -e "${NC}"
}

banner

# ─── Build + Start ───
echo -e "${YELLOW}[1/3] Iniciando containers (pode demorar na primeira vez)...${NC}"
docker compose up -d --build

# ─── Aguarda HDFS estar saudável ───
echo -e "${YELLOW}[2/3] Aguardando o HDFS inicializar...${NC}"
until docker exec namenode hdfs dfsadmin -safemode get 2>/dev/null | grep -q "Safe mode is OFF"; do
  echo -e "      Aguardando NameNode sair do Safe Mode..."
  sleep 10
done
echo -e "      NameNode pronto."

# ─── Inicializa diretórios no HDFS ───
echo -e "${YELLOW}[3/3] Criando estrutura de diretórios no HDFS...${NC}"
docker exec namenode hdfs dfs -mkdir -p /user/root
docker exec namenode hdfs dfs -mkdir -p /user/aluno
docker exec namenode hdfs dfs -mkdir -p /user/hive/warehouse
docker exec namenode hdfs dfs -mkdir -p /user/hue
docker exec namenode hdfs dfs -mkdir -p /tmp/hive
docker exec namenode hdfs dfs -chmod -R 777 /tmp
docker exec namenode hdfs dfs -chmod -R 777 /user

# ─── Resumo ───
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Ambiente pronto! Acesse:               ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${CYAN}Interface principal (Hue):${NC}"
echo -e "    http://localhost:8888  →  usuário: qualquer / senha: qualquer (1º login vira admin)"
echo ""
echo -e "  ${CYAN}Interfaces Hadoop:${NC}"
echo -e "    HDFS NameNode Web UI:         http://localhost:9870"
echo -e "    YARN ResourceManager Web UI:  http://localhost:8088"
echo -e "    MapReduce History Server:      http://localhost:8188"
echo -e "    HiveServer2 Web UI:            http://localhost:10002"
echo ""
echo -e "  ${CYAN}MySQL (fonte Sqoop):${NC}"
echo -e "    Host: localhost:3306  |  database: impacta"
echo -e "    root: root / root123"
echo -e "    sqoop user: sqoop / sqoop123"
echo ""
echo -e "  ${CYAN}Entrar no container Sqoop:${NC}"
echo -e "    docker exec -it sqoop bash"
echo ""
echo -e "  ${CYAN}Exemplo Sqoop import:${NC}"
echo -e "    sqoop import \\"
echo -e "      --connect jdbc:mysql://mysql:3306/impacta \\"
echo -e "      --username sqoop --password sqoop123 \\"
echo -e "      --table employees --target-dir /user/aluno/employees \\"
echo -e "      --m 1"
echo ""
echo -e "  ${CYAN}Parar o ambiente:${NC}"
echo -e "    docker compose down"
echo ""
