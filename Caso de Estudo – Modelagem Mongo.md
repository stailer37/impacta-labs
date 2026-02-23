#  Caso de Estudo – Modelagem MongoDB
## Empresa Amazonas – E-commerce
## Aluno
    Augusto Cardone
    RA: 2503727

## Contexto da Empresa

    A empresa Amazonas do ramo de e-commerce deseja acompanhar os fluxos de cliques de seus clientes, bem como rastrear os produtos que eles compram.Neste momento, a empresa vende livros, CDs e pequenos eletrodomésticos de cozinha apenas, mas provavelmente irá expandir para outros produtos no futuro.

## A empresa deseja responder às seguintes perguntas de negócio:

1. Qual é a média de produtos comprados por cliente?

2. Quais são os 20 produtos mais populares por estado dos clientes?

3. Qual é o valor médio das vendas por estado do cliente?

4. Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?

### Modelagem Adotada

Optou-se pela utilização de múltiplas collections:

1. customers

2. products

3. orders

4. click_events

A seguir, a justificativa de cada uma.

1. Clientes (customers)

 Criou-se uma collection específica para armazenar os dados dos clientes porque:

    - Um cliente pode realizar vários pedidos.

    - Evita repetição de nome, e-mail e estado em cada compra.

    - Facilita análises e agrupamentos por estado.

    - Caso essas informações fossem armazenadas apenas na collection de pedidos, haveria redundância desnecessária de dados.

2. Produtos (products)

 A collection de produtos funciona como um catálogo. Ela armazena informações como:

    - Nome

    - Categoria

    - Preço atual

 Essa separação permite que novos tipos de produtos sejam adicionados futuramente sem necessidade de alterar a estrutura das demais collections.

3. Pedidos (orders)

 A collection orders representa a compra realizada pelo cliente.

 Os itens foram inseridos dentro do pedido como um array porque:

    - Um pedido sempre é consultado junto com seus itens.

    - Simplifica as consultas.

    - Evita a necessidade de junção entre collections.

 Além disso, foram incluídos no pedido:

    - O estado do cliente no momento da compra

    - O preço unitário do produto

    - A categoria do produto

 Isso garante que o histórico da venda seja mantido corretamente, mesmo que o cadastro do cliente ou do produto seja alterado no futuro.

4. Eventos de Clique (click_events)

 A collection click_events foi criada para armazenar os eventos de navegação. Ela é separada porque:

    - Representa comportamento do usuário, não vendas.

    - Pode crescer muito mais rapidamente que a collection de pedidos.

    - Permite análises futuras de comportamento e interesse.

Separar esses dados evita misturar informações transacionais com dados analíticos.

#### Criar o banco e collections via mongosh
mongosh <<EOF
use amazonas
db.createCollection("customers")
db.createCollection("products")
db.createCollection("orders")
db.createCollection("click_events")
EOF

#### Importar os dados JSON
mongoimport --db amazonas --collection customers --file collection_customers.json --jsonArray
mongoimport --db amazonas --collection products --file collection_products.json --jsonArray
mongoimport --db amazonas --collection orders --file collection_orders.json --jsonArray
mongoimport --db amazonas --collection click_events --file collection_click_events.json --jsonArray

##### Pergunta Escolhida

Qual é o valor médio das vendas por estado do cliente?

```javascript 
mongosh <<EOF
use amazonas;

// Pergunta respondida -  Qual é o valor médio das vendas por estado do cliente?
var mediaVendas = db.orders.aggregate([
  { \$unwind: "\$items" },
  { \$group: { _id: "\$state", media_valor_vendas: { \$avg: { \$multiply: ["\$items.unit_price", "\$items.quantity"] } } } }
]).toArray();
printjson(mediaVendas);
EOF
``` 
Esse comando:

 - Seleciona o banco: use amazonas.

 - Separa cada item do pedido: $unwind: "$items".

 - Agrupa por estado e calcula a média de vendas multiplicando quantidade × preço unitário de cada item.

 - Mostra o resultado em formato JSON: printjson(mediaVendas).

###### Estrutura do Projeto
feat/caso_estudo_amazonas

README.md
collection_customers.json
collection_products.json
collection_orders.json
collection_click_events.json
command_mongo.sh

###### Conclusão

A modelagem proposta organiza os dados de forma clara, evita redundâncias desnecessárias e facilita a realização das consultas solicitadas no estudo de caso.

A estrutura também permite crescimento futuro do catálogo de produtos e expansão das análises de negócio.
