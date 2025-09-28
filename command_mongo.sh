set -euo pipefail

echo ""
echo "===================================================="
echo "Caso de Estudo NoSQL Documento - AMAZONAS E-COMMERCE"
echo "===================================================="
echo ""

# Parâmetros
DOCKER_CONTAINER="mongodb-standalone"
DB_NAME="test"

# Função para executar comandos no container MongoDB
run_mongo() {
    docker exec -i $DOCKER_CONTAINER mongosh --eval "$1"
}

# Função para executar comandos silenciosos (setup)
run_mongo_quiet() {
    docker exec -i $DOCKER_CONTAINER mongosh --quiet --eval "$1"
}

# Função para importar JSON no container
import_json() {
    local collection=$1
    local file=$2
    # Copiar arquivo para o container
    docker cp "$file" $DOCKER_CONTAINER:/tmp/
    # Importar JSON
    docker exec -i $DOCKER_CONTAINER mongoimport \
        --db $DB_NAME \
        --collection $collection \
        --file /tmp/$file \
        --jsonArray \
        --drop
    # Remover arquivo temporário do container
    docker exec -i $DOCKER_CONTAINER rm /tmp/$file
}
echo "=== ETAPA 1: IMPORTAÇÃO DAS COLEÇÕES ==="
echo ""
# Importar coleção transactions
import_json "transactions" "collection_transactions.json"

# Importar coleção clickstream  
import_json "clickstream" "collection_clickstream.json"

# Verificar importação
run_mongo_quiet "
var transactionCount = db.transactions.countDocuments();
var clickstreamCount = db.clickstream.countDocuments();

print('Importação concluída:');
print('   Transactions: ' + transactionCount + ' documentos');
print('   Clickstream: ' + clickstreamCount + ' documentos');

if (transactionCount === 0 || clickstreamCount === 0) {
    print('Erro na importação! Verifique os arquivos JSON.');
    quit(1);
}
"
echo ""

echo "=== ETAPA 2: CRIAÇÃO DOS ÍNDICES ==="

run_mongo_quiet "

// Índices básicos para transactions
db.transactions.createIndex({ 'customer_state': 1 });
db.transactions.createIndex({ 'transaction_date': -1 });
db.transactions.createIndex({ 'customer_id': 1 });
db.transactions.createIndex({ 'customer_segment': 1 });
db.transactions.createIndex({ 'customer_email': 1 });
db.transactions.createIndex({ 'products.category': 1 });
db.transactions.createIndex({ 'products.product_id': 1 });

// Índices compostos para consultas específicas
db.transactions.createIndex({ 'customer_state': 1, 'transaction_date': -1 });
db.transactions.createIndex({ 'customer_segment': 1, 'customer_state': 1 });
db.transactions.createIndex({ 'transaction_date': -1, 'products.category': 1 });

// Índices básicos para clickstream
db.clickstream.createIndex({ 'event_timestamp': -1 });
db.clickstream.createIndex({ 'customer_id': 1, 'event_timestamp': -1 });
db.clickstream.createIndex({ 'session_id': 1 });
db.clickstream.createIndex({ 'event_type': 1 });
db.clickstream.createIndex({ 'product_id': 1 });
db.clickstream.createIndex({ 'product_category': 1 });

// Índices para marketing e analytics
db.clickstream.createIndex({ 'utm_source': 1, 'utm_medium': 1 });
db.clickstream.createIndex({ 'event_type': 1, 'product_category': 1 });
db.clickstream.createIndex({ 'session_id': 1, 'event_timestamp': 1 });

// TTL Index para limpeza automática (90 dias)
db.clickstream.createIndex(
    { 'event_timestamp': 1 }, 
    { expireAfterSeconds: 7776000, name: 'ttl_cleanup_90days' }
);

// Verificar índices criados
print('\\n Índices criados na coleção Transactions:');
db.transactions.getIndexes().forEach(function(index) {
    if (index.name !== '_id_') {
        print('  - ' + index.name + ': ' + JSON.stringify(index.key));
    }
});

print('\\n Índices criados na coleção Clickstream:');
db.clickstream.getIndexes().forEach(function(index) {
    if (index.name !== '_id_') {
        print('  - ' + index.name + ': ' + JSON.stringify(index.key));
    }
});
"
echo ""