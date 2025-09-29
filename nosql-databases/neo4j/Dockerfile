# Use a imagem oficial do Neo4j como base
FROM neo4j:latest

# Defina o diretório de trabalho
WORKDIR /var/lib/neo4j

# Exponha as portas padrão do Neo4j
EXPOSE 7474 7687

# Configure variáveis de ambiente
ENV NEO4J_AUTH=neo4j/impacta@labs \
    NEO4J_dbms_memory_heap_initial__size=512m \
    NEO4J_dbms_memory_heap_max__size=1G

# Inicie o Neo4j
CMD ["neo4j"]