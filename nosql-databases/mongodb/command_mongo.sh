# 1. Acessa o shell do MongoDB no contêiner Docker 'mongodb-standalone' (Versão 4.4 do mongo)
docker exec -it mongodb-standalone mongo

# Uma vez dentro do shell do Mongo, execute os comandos abaixo sequencialmente:

# 2. Usa o database "amazonas"
use amazonas

# 3. Insere os registros na collection "cliques"
db.cliques.insertMany([
  {
    "id_evento": "1",
    "id_cliente": "cliente_123",
    "timestamp": {
      "$date": "2025-09-17T09:55:00Z"
    },
    "tipo_evento": "visualizacao_produto",
    "detalhes_evento": {
      "id_produto": "2"
    }
  },
  {
    "id_evento": "2",
    "id_cliente": "cliente_123",
    "timestamp": {
      "$date": "2025-09-17T09:58:00Z"
    },
    "tipo_evento": "adicionar_carrinho",
    "detalhes_evento": {
      "id_produto": "2"
    }
  },
  {
    "id_evento": "3",
    "id_cliente": "cliente_123",
    "timestamp": {
      "$date": "2025-09-17T09:58:00Z"
    },
    "tipo_evento": "visualizacao_produto",
    "detalhes_evento": {
      "id_produto": "1"
    }
  },
  {
    "id_evento": "4",
    "id_cliente": "cliente_123",
    "timestamp": {
      "$date": "2025-09-17T09:59:00Z"
    },
    "tipo_evento": "adicionar_carrinho",
    "detalhes_evento": {
      "id_produto": "1"
    }
  },
  {
    "id_evento": "5",
    "id_cliente": "cliente_456",
    "timestamp": {
      "$date": "2025-09-18T09:58:00Z"
    },
    "tipo_evento": "visualizacao_produto",
    "detalhes_evento": {
      "id_produto": "3"
    }
  },
  {
    "id_evento": "6",
    "id_cliente": "cliente_456",
    "timestamp": {
      "$date": "2025-09-18T09:59:00Z"
    },
    "tipo_evento": "adicionar_carrinho",
    "detalhes_evento": {
      "id_produto": "3"
    }
  }
])

# 4. Insere os registros na collection "produtos"
db.produtos.insertMany([
  {
    "id_produto": "1",
    "nome": "O Hobbit",
    "valor_unitario": 49.90,
    "tipo_produto": "livro",
    "quantidade_estoque": 150,
    "descricao": {
      "autor": "J.R.R. Tolkien",
      "paginas": 320,
      "editora": "HarperCollins Brasil"
    }
  },
  {
    "id_produto": "2",
    "nome": "Liquidificador Philips Walita ProBlend 6",
    "valor_unitario": 299.99,
    "tipo_produto": "eletrodomestico",
    "quantidade_estoque": 50,
    "descricao": {
      "voltagem": "110V/220V",
      "potencia_watts": 800,
      "capacidade_litros": 2
    }
  },
  {
    "id_produto": "3",
    "nome": "CD The Dark Side of the Moon",
    "valor_unitario": 39.90,
    "tipo_produto": "cd",
    "quantidade_estoque": 80,
    "descricao": {
      "banda": "Pink Floyd",
      "genero": "Rock Progressivo"
    }
  }
])

# 5. Insere os registros na collection "pedidos"
db.pedidos.insertMany([
  {
    "id_pedido": "1",
    "id_cliente": "cliente_123",
    "estado_cliente": "SP",
    "data_compra": {
      "$date": "2025-09-17T10:00:00Z"
    },
    "valor_total": 389.79,
    "produtos": [
      {
        "id_produto": "2",
        "nome_produto": "Liquidificador Philips Walita ProBlend 6",
        "valor_pago": 299.99,
        "quantidade_comprada": 1
      },
      {
        "id_produto": "1",
        "nome_produto": "O Hobbit",
        "valor_pago": 49.90,
        "quantidade_comprada": 2
      }
    ]
  },
  {
    "id_pedido": "2",
    "id_cliente": "cliente_456",
    "estado_cliente": "MG",
    "data_compra": {
      "$date": "2025-09-17T11:30:00Z"
    },
    "valor_total": 39.90,
    "produtos": [
      {
        "id_produto": "3",
        "nome_produto": "CD The Dark Side of the Moon",
        "valor_pago": 39.90,
        "quantidade_comprada": 1
      }
    ]
  }
])

# 6. Lista as collections do database atual
show collections

# 7. Executa a query de agregação para calcular o valor médio de vendas por estado
db.pedidos.aggregate([
  {
    $group: {
      _id: "$estado_cliente",
      valor_medio_vendas: { $avg: "$valor_total" }
    }
  },
  {
    $sort: { "_id": 1 }
  }
])
