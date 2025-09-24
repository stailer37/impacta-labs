Grupo:

Henrique Alves de Souza Davanço RA: 2502254

Ivan Aldecoa Rosseto RA: 2501260

Carina de Oliveira RA: 2100205

Kauan Gomes RA: 2502147

João Pedro Moreira Alonso - RA: 2500701

Lucas Gouveia RA: 2500399

Anderson Oliveira dos Santos RA: 2500159






#################################ESTRUTURA JSON########################



*Estrutura das Coleções*


Coleção: customers.json
{
  "_id": "C123",
  "name": "João Santos",
  "email": "joao.santos@email.com",
  "state": "SP",
  "created_at": "2025-03-22T10:15:00Z"
}


Campos escolhidos:

_id → identificador único do cliente.

state → essencial para relatórios por região.

created_at → auditoria e análise de retenção.

--------------------------------------------- 

Coleção: products.json
{
  "_id": "P456",
  "name": "Livro - MongoDB Essencial",
  "category": "Livro",
  "price": 89.90,
  "created_at": "2025-07-15T12:00:00Z"
}

{
  "_id": "P789",
  "name": "Aspirador Turbo",
  "category": "Eletrodomestico",
  "price": 150.00,
  "created_at": "2025-06-10T12:00:00Z"
}

Campos escolhidos:

category → importante para diferenciar CDs, livros e eletrodomésticos.

price → para cálculos de valor médio de vendas.

-------------------------------------------------------

Coleção: sales.json
{
  "_id": "S789",
  "customer_id": "C123",
  "products": [
    { "product_id": "P456", "quantity": 2 },
    { "product_id": "P789", "quantity": 1 }
  ],
  "total_amount": 329.80,
  "created_at": "2025-08-19T15:30:00Z"
}


Campos escolhidos:

products[] → lista de itens comprados, suporta múltiplos produtos.

total_amount → evita recalcular somas em consultas frequentes.

created_at → necessário para relatórios de período (ex: últimos 30 dias).


--------------------------------------------------------


3. Exemplo de Evento JSON Sistêmico

Um evento de compra registrada poderia ser enviado ao MongoDB no seguinte formato:

{
  "event": "purchase",
  "timestamp": "2025-08-19T15:30:00Z",
  "customer_id": "C123",
  "products": [
    { "product_id": "P456", "quantity": 2 },
    { "product_id": "P789", "quantity": 1 }
  ],
  "total_amount": 329.80
}

------------------------------------------------
####################################################
PERGUNTA ESCOLHIDA:

Qual é o valor médio das vendas por estado do cliente?

####################################################


Arquivo command_mongo.sh:

#!/bin/bash
mongo <<EOF
use amazonas

db.sales.aggregate([
  {
    \$lookup: {
      from: "customers",
      localField: "customer_id",
      foreignField: "_id",
      as: "customer"
    }
  },
  { \$unwind: "\$customer" },
  {
    \$group: {
      _id: "\$customer.state",
      average_sales: { \$avg: "\$total_amount" }
    }
  },
  { \$sort: { average_sales: -1 } }
])
EOF


Esse comando faz:

lookup → junta as vendas com os clientes.

group por estado do cliente.

Calcula a média de vendas por estado.

Ordena do maior para o menor.




##################COMANDOS MONGODB#################################


use amazonas

db.customers.insertOne({
  "_id": "C123",
  "name": "João Santos",
  "email": "joao.santos@email.com",
  "state": "SP",
  "created_at": ISODate("2025-03-22T10:15:00Z")
})

db.products.insertOne({
  "_id": "P456",
  "name": "Livro - MongoDB Essencial",
  "category": "Livro",
  "price": 89.90,
  "created_at": ISODate("2025-07-15T12:00:00Z")
})

db.products.insertOne({
  "_id": "P789",
  "name": "Aspirador Turbo",
  "category": "Eletrodomestico",
  "price": 150.00,
  "created_at": ISODate("2025-06-10T12:00:00Z")
})

db.sales.insertOne({
  "_id": "S789",
  "customer_id": "C123",
  "products": [
    { "product_id": "P456", "quantity": 2 },
    { "product_id": "P789", "quantity": 1 }
  ],
  "total_amount": 329.80,
  "created_at": ISODate("2025-08-19T15:30:00Z")
})

----------------------------------------------------------------------------------

db.events.insertOne({
  "event": "purchase",
  "timestamp": ISODate("2025-08-19T15:30:00Z"),
  "customer_id": "C123",
  "products": [
    { "product_id": "P456", "quantity": 2 },
    { "product_id": "P789", "quantity": 1 }
  ],
  "total_amount": 329.80
})


----------------------------------------------------------------

db.sales.aggregate([
  {
    $lookup: {
      from: "customers",
      localField: "customer_id",
      foreignField: "_id",
      as: "customer"
    }
  },
  { $unwind: "$customer" },
  {
    $group: {
      _id: "$customer.state",
      average_sales: { $avg: "$total_amount" }
    }
  },
  { $sort: { average_sales: -1 } }
])



