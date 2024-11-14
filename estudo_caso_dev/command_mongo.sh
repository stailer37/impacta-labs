#Comando para inserir vários registros na collection "compras"
#Neste caso estamos colocando o conteudo de "collection_compras.json"
db.compras.insertMany([
    {
      "cliente": {
        "cliente_id": "12345",
        "nome": "João Silva",
        "estado": "SP"
      },
      "produto": {
        "produto_id": "001",
        "nome": "Produto A",
        "categoria": "Eletrônicos"
      },
      "data_compra": "2024-11-01T10:15:30Z",
      "quantidade": 1,
      "preco": 299.99
    },
    {
      "cliente": {
        "cliente_id": "67890",
        "nome": "Maria Santos",
        "estado": "RJ"
      },
      "produto": {
        "produto_id": "002",
        "nome": "Produto B",
        "categoria": "Eletrodomésticos"
      },
      "data_compra": "2024-11-02T12:30:00Z",
      "quantidade": 2,
      "preco": 159.90
    },
    {
      "cliente": {
        "cliente_id": "11223",
        "nome": "Carlos Pereira",
        "estado": "SP"
      },
      "produto": {
        "produto_id": "001",
        "nome": "Produto A",
        "categoria": "Eletrônicos"
      },
      "data_compra": "2024-11-03T15:45:10Z",
      "quantidade": 1,
      "preco": 299.99
    },
    {
      "cliente": {
        "cliente_id": "44556",
        "nome": "Ana Oliveira",
        "estado": "MG"
      },
      "produto": {
        "produto_id": "003",
        "nome": "Produto C",
        "categoria": "Vestuário"
      },
      "data_compra": "2024-11-04T09:00:00Z",
      "quantidade": 1,
      "preco": 79.99
    }
  ])

#Comando para responder a pergunta de negócio
#Qual é a média de quantidade de produtos comprados por cliente?
db.compras.aggregate([
  { $group: { _id: "média de quantidade de produtos comprados", total: { $avg: "$quantidade" } } }
])






#Outras Perguntas que podemos responder

#Quantidade Média de produtos comprados por estado
db.compras.aggregate([
  { $group: { _id: "$cliente.estado", total: { $avg: "$quantidade" } } }
])

#Quantidade total de produtos comprados por cliente
db.compras.aggregate([
  { $group: { _id: "$cliente.nome", total: { $sum: "$quantidade" } } }
])

#Quantidade total de produtos comprados
db.compras.aggregate([
  { $group: { _id: "Quantidade total de produtos comprados", total: { $sum: "$quantidade" } } }
])


#Quantidade total de produtos comprados por categoria
db.compras.aggregate([
  { $group: { _id: "$produto.categoria", total: { $sum: "$quantidade" } } }
])

#Preço mínimo de produtos por categoria
db.compras.aggregate([
  { $group: { _id: "$produto.nome", total: { $min: "$preco" } } }
])