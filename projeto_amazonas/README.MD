### Nome dos integrantes:
    Mateus Forner Gimenes

### Justificativa do uso de multiplas collections:
    Optei por dividir os dados em duas collection principais para otimizar o desempenho e a escalabilidade.


### Como Executar o Projeto

1.  **Subir o MongoDB (Docker):**
    docker compose up -d
    

2.  **Importar os Dados de Exemplo (JSONs):**
    # Transações (Importação via stdin para evitar problemas de caminho)
    cat collection_transactions.json | docker exec -i mongodb_db mongoimport --db amazonas_ecommerce --collection transactions --jsonArray --drop

    # Eventos
    cat collection_events.json | docker exec -i mongodb_db mongoimport --db amazonas_ecommerce --collection events --jsonArray --drop
    

3.  **Executar a Consulta de Negócio (`command_mongo.sh`):**
    * Pergunta Respondida: Quais são os 20 produtos mais populares por estado?
    # Executa o script de agregação no container MongoDB
    cat command_mongo.sh | docker exec -i mongodb_db mongosh amazonas_ecommerce

