# Comando para inserir dados na collection de clientes
db.clientes.insertMany([
    {
        "id_cliente": 101,
        "nome_cliente": "Mariana Costa",
        "email_cliente": "mariana.costa@email.com",
        "estado_cliente": "SP"
    },
    {
        "id_cliente": 102,
        "nome_cliente": "Rafael Almeida",
        "email_cliente": "rafael.almeida@email.com",
        "estado_cliente": "RJ"
    },
    {
        "id_cliente": 103,
        "nome_cliente": "Carolina Mendes",
        "email_cliente": "carolina.mendes@email.com",
        "estado_cliente": "MG"
    },
    {
        "id_cliente": 104,
        "nome_cliente": "Felipe Santos",
        "email_cliente": "felipe.santos@email.com",
        "estado_cliente": "BA"
    },
    {
        "id_cliente": 105,
        "nome_cliente": "Amanda Rocha",
        "email_cliente": "amanda.rocha@email.com",
        "estado_cliente": "PE"
    },
    {
        "id_cliente": 106,
        "nome_cliente": "Gustavo Ferreira",
        "email_cliente": "gustavo.ferreira@email.com",
        "estado_cliente": "RS"
    },
    {
        "id_cliente": 107,
        "nome_cliente": "Patrícia Lima",
        "email_cliente": "patricia.lima@email.com",
        "estado_cliente": "SP"
    },
    {
        "id_cliente": 108,
        "nome_cliente": "Henrique Moreira",
        "email_cliente": "henrique.moreira@email.com",
        "estado_cliente": "PR"
    }
])

# Comando para inserir dados na collection de produtos
db.produtos.insertMany([
    {
        "id_produto": 1001,
        "nome_produto": "Frozen II",
        "categoria_produto": "DVD",
        "preco_produto": 29.90
    },
    {
        "id_produto": 1002,
        "nome_produto": "Dom Casmurro",
        "categoria_produto": "Livro",
        "preco_produto": 54.00
    },
    {
        "id_produto": 1003,
        "nome_produto": "Liquidificador Philips",
        "categoria_produto": "Eletrodoméstico",
        "preco_produto": 189.90
    },
    {
        "id_produto": 1004,
        "nome_produto": "Avengers: Endgame",
        "categoria_produto": "DVD",
        "preco_produto": 39.90
    },
    {
        "id_produto": 1005,
        "nome_produto": "Batedeira Arno",
        "categoria_produto": "Eletrodoméstico",
        "preco_produto": 420.00
    },
    {
        "id_produto": 1006,
        "nome_produto": "Queen Greatest Hits",
        "categoria_produto": "CD",
        "preco_produto": 59.99
    },
    {
        "id_produto": 1007,
        "nome_produto": "Legião Urbana – Acústico",
        "categoria_produto": "CD",
        "preco_produto": 45.00
    },
    {
        "id_produto": 1008,
        "nome_produto": "Tropa de Elite",
        "categoria_produto": "DVD",
        "preco_produto": 27.50
    },
    {
        "id_produto": 1009,
        "nome_produto": "Harry Potter e a Pedra Filosofal",
        "categoria_produto": "Livro",
        "preco_produto": 72.90
    },
    {
        "id_produto": 1010,
        "nome_produto": "Air Fryer Mondial",
        "categoria_produto": "Eletrodoméstico",
        "preco_produto": 599.90
    },
    {
        "id_produto": 1011,
        "nome_produto": "Chico Buarque – Ao Vivo",
        "categoria_produto": "CD",
        "preco_produto": 38.00
    }
])

# Comando para inserir dados na collection de clicks
db.clicks.insertMany([
    {
        "id_click": 10024567,
        "id_cliente": 101,
        "id_produto": 1001,
        "timestamp": "2025-09-05T14:32:10Z"
    },
    {
        "id_click": 10024568,
        "id_cliente": 102,
        "id_produto": 1002,
        "timestamp": "2025-09-12T19:47:55Z"
    },
    {
        "id_click": 10024569,
        "id_cliente": 103,
        "id_produto": 1003,
        "timestamp": "2025-09-20T08:15:44Z"
    },
    {
        "id_click": 10024570,
        "id_cliente": 104,
        "id_produto": 1004,
        "timestamp": "2025-09-25T11:03:28Z"
    },
    {
        "id_click": 10024571,
        "id_cliente": 105,
        "id_produto": 1005,
        "timestamp": "2025-09-29T21:56:02Z"
    },
    {
        "id_click": 10024572,
        "id_cliente": 106,
        "id_produto": 1006,
        "timestamp": "2025-09-30T09:41:12Z"
    },
    {
        "id_click": 10024573,
        "id_cliente": 107,
        "id_produto": 1007,
        "timestamp": "2025-09-30T10:05:37Z"
    },
    {
        "id_click": 10024574,
        "id_cliente": 108,
        "id_produto": 1008,
        "timestamp": "2025-09-30T11:25:49Z"
    }
])

# Comando para inserir dados na collection de vendas
db.vendas.insertMany([
    {
        "id_venda": 5001,
        "id_cliente": 101,
        "timestamp_venda": "2025-09-03T15:22:18Z",
        "total_venda": 129.80,
        "produtos": [
            { "id_produto": 1001, "quantidade": 2, "preco_unidade": 29.90 },
            { "id_produto": 1002, "quantidade": 1, "preco_unidade": 54.00 }
        ]
    },
    {
        "id_venda": 5002,
        "id_cliente": 103,
        "timestamp_venda": "2025-09-05T11:45:50Z",
        "total_venda": 189.90,
        "produtos": [
            { "id_produto": 1003, "quantidade": 1, "preco_unidade": 189.90 }
        ]
    },
    {
        "id_venda": 5003,
        "id_cliente": 104,
        "timestamp_venda": "2025-09-07T19:12:33Z",
        "total_venda": 99.90,
        "produtos": [
            { "id_produto": 1004, "quantidade": 1, "preco_unidade": 39.90 },
            { "id_produto": 1006, "quantidade": 1, "preco_unidade": 59.99 }
        ]
    },
    {
        "id_venda": 5004,
        "id_cliente": 105,
        "timestamp_venda": "2025-09-08T09:57:21Z",
        "total_venda": 420.00,
        "produtos": [
            { "id_produto": 1005, "quantidade": 1, "preco_unidade": 420.00 }
        ]
    },
    {
        "id_venda": 5005,
        "id_cliente": 102,
        "timestamp_venda": "2025-09-10T14:41:37Z",
        "total_venda": 72.50,
        "produtos": [
            { "id_produto": 1008, "quantidade": 1, "preco_unidade": 27.50 },
            { "id_produto": 1011, "quantidade": 1, "preco_unidade": 38.00 },
            { "id_produto": 1007, "quantidade": 1, "preco_unidade": 45.00 }
        ]
    },
    {
        "id_venda": 5006,
        "id_cliente": 108,
        "timestamp_venda": "2025-09-12T20:28:15Z",
        "total_venda": 599.90,
        "produtos": [
            { "id_produto": 1010, "quantidade": 1, "preco_unidade": 599.90 }
        ]
    },
    {
        "id_venda": 5007,
        "id_cliente": 107,
        "timestamp_venda": "2025-09-14T16:11:09Z",
        "total_venda": 101.90,
        "produtos": [
            { "id_produto": 1009, "quantidade": 1, "preco_unidade": 72.90 },
            { "id_produto": 1001, "quantidade": 1, "preco_unidade": 29.90 }
        ]
    },
    {
        "id_venda": 5008,
        "id_cliente": 106,
        "timestamp_venda": "2025-09-18T18:34:44Z",
        "total_venda": 84.00,
        "produtos": [
            { "id_produto": 1002, "quantidade": 1, "preco_unidade": 54.00 },
            { "id_produto": 1008, "quantidade": 1, "preco_unidade": 27.50 }
        ]
    },
    {
        "id_venda": 5009,
        "id_cliente": 103,
        "timestamp_venda": "2025-09-22T12:21:59Z",
        "total_venda": 144.99,
        "produtos": [
            { "id_produto": 1006, "quantidade": 1, "preco_unidade": 59.99 },
            { "id_produto": 1007, "quantidade": 1, "preco_unidade": 45.00 },
            { "id_produto": 1011, "quantidade": 1, "preco_unidade": 38.00 }
        ]
    },
    {
        "id_venda": 5010,
        "id_cliente": 101,
        "timestamp_venda": "2025-09-28T21:40:10Z",
        "total_venda": 669.80,
        "produtos": [
            { "id_produto": 1010, "quantidade": 1, "preco_unidade": 599.90 },
            { "id_produto": 1002, "quantidade": 1, "preco_unidade": 54.00 },
            { "id_produto": 1001, "quantidade": 1, "preco_unidade": 29.90 }
        ]
    }
])

# -------------------------------------------------------------------------------------------------
# Qual é a média de produtos comprados por cliente?

db.vendas.aggregate([
    {$unwind:"$produtos"},
    {$group:{_id:"$id_cliente", total_produtos:{$sum:"$produtos.quantidade"}}},
    {$group:{_id:null, media_produtos:{$avg:"$total_produtos"}}}
])