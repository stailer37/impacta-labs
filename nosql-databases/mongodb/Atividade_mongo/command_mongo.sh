# Inserindo os dados na collection de clientes
db.clientes.insertMany([
    {
        "id_cliente": 2,
        "nome_cliente": "Diogo",
        "email_cliente": "diogo@email.com",
        "estado_cliente": "SP"
    },
    {
        "id_cliente": 6,
        "nome_cliente": "Antonio",
        "email_cliente": "antonio@email.com",
        "estado_cliente": "SP"
    },
    {
        "id_cliente": 12,
        "nome_cliente": "Bruno",
        "email_cliente": "bruno@email.com",
        "estado_cliente": "SP"
    },
    {
        "id_cliente": 22,
        "nome_cliente": "Santana",
        "email_cliente": "santana@email.com",
        "estado_cliente": "RJ"
    },
    {
        "id_cliente": 35,
        "nome_cliente": "Jose",
        "email_cliente": "jose@email.com",
        "estado_cliente": "RJ"
    },
    {
        "id_cliente": 27,
        "nome_cliente": "Silvio",
        "email_cliente": "silvio@email.com",
        "estado_cliente": "PE"
    }
])

# Inserindo dados na collection de produtos
db.produtos.insertMany([
    {
        "id_produto": 154,
        "nome_produto": "Shrek 2",
        "categoria_produto": "DVD",
        "preco_produto": 25.90
    },
    {
        "id_produto": 155,
        "nome_produto": "O memino do pijama listrado",
        "categoria_produto": "Livro",
        "preco_produto": 68.00
    },
    {
        "id_produto": 254,
        "nome_produto": "Mixer",
        "categoria_produto": "Eletrodoméstico",
        "preco_produto": 150.00
    },
    {
        "id_produto": 322,
        "nome_produto": "Homem de Ferro 3",
        "categoria_produto": "DVD",
        "preco_produto": 25.90
    },
    {
        "id_produto": 333,
        "nome_produto": "Multiprocessador",
        "categoria_produto": "Eletrodoméstico",
        "preco_produto": 360.00
    },
    {
        "id_produto": 878,
        "nome_produto": "System of A Down",
        "categoria_produto": "CD",
        "preco_produto": 64.99
    },
    {
        "id_produto": 455,
        "nome_produto": "Linkin Park",
        "categoria_produto": "CD",
        "preco_produto": 68.50
    },
    {
        "id_produto": 457,
        "nome_produto": "O auto da compadecida",
        "categoria_produto": "DVD",
        "preco_produto": 25.90
    },
    {
        "id_produto": 778,
        "nome_produto": "300",
        "categoria_produto": "DVD",
        "preco_produto": 35
    },
    {
        "id_produto": 566,
        "nome_produto": "Microondas",
        "categoria_produto": "Eletrodoméstico",
        "preco_produto": 344.99
    },
    {
        "id_produto": 229,
        "nome_produto": "Emicida",
        "categoria_produto": "CD",
        "preco_produto": 24.50
    }
])

# Inserindo dados na collection de clicks
db.clicks.insertMany([
    {
        "id_click": 23154621,
        "id_cliente": 12,
        "id_produto": 455,
        "timestamp": new Date("2025-09-21T17:50:00Z")
    },
    {
        "id_click": 4554524,
        "id_cliente": 6,
        "id_produto": 778,
        "timestamp": new Date("2025-09-14T17:51:48Z")
    },
    {
        "id_click": 5465215,
        "id_cliente": 22,
        "id_produto": 566,
        "timestamp": new Date("2025-09-29T10:20:33Z")
    },
    {
        "id_click": 4521533,
        "id_cliente": 12,
        "id_produto": 154,
        "timestamp": new Date("2025-09-01T09:22:41Z")
    },
    {
        "id_click": 2458998,
        "id_cliente": 27,
        "id_produto": 333,
        "timestamp": new Date("2025-09-06T22:49:23Z")
    }
])

# Inserindo dados na collection de vendas
db.vendas.insertMany([
    {
        "id_venda": 2345,
        "id_cliente": 6,
        "timestamp_venda": new Date("2025-09-06T22:49:23Z"),
        "total_venda": 175.90,
        "produtos": [
            {
                "id_produto": 254,
                "quantidade": 1,
                "preco_unidade": 150.00
            },
            {
                "id_produto": 154,
                "quantidade": 1,
                "preco_unidade": 25.90
            }
        ]
    },
    {
        "id_venda": 1113,
        "id_cliente": 12,
        "timestamp_venda": new Date("2025-09-04T12:33:11Z"),
        "total_venda": 133.49,
        "produtos": [
            {
                "id_produto": 455,
                "quantidade": 1,
                "preco_unidade": 68.50
            },
            {
                "id_produto": 878,
                "quantidade": 1,
                "preco_unidade": 64.99
            }
        ]
    },
    {
        "id_venda": 6654,
        "id_cliente": 2,
        "timestamp_venda": new Date("2025-09-18T19:03:45Z"),
        "total_venda": 360.00,
        "produtos": [
            {
                "id_produto": 333,
                "quantidade": 1,
                "preco_unidade": 360.00
            }
        ]
    },
    {
        "id_venda": 2887,
        "id_cliente": 2,
        "timestamp_venda": new Date("2025-09-20T20:58:55Z"),
        "total_venda": 77.7,
        "produtos": [
            {
                "id_produto": 154,
                "quantidade": 3,
                "preco_unidade": 25.90
            }
        ]
    },
    {
        "id_venda": 8865,
        "id_cliente": 22,
        "timestamp_venda": new Date("2025-09-02T21:05:40Z"),
        "total_venda": 49.0,
        "produtos": [
            {
                "id_produto": 229,
                "quantidade": 2,
                "preco_unidade": 24.50
            }
        ]
    }
])

# -------------------------------------------------------------------------------------------------
# Qual é a média de produtos comprados por cliente?

db.vendas.aggregate([
    {$unwind:"$produtos"},
    {$group:{_id:"$id_cliente", q_produtos_comprados:{$sum:"$produtos.quantidade"}}},
    {$group:{_id:null, media_produtos:{$avg:"$q_produtos_comprados"}}}
])

# Qual é o valor médio das vendas por estado do cliente?
db.vendas.aggregate([
    {$lookup:{from:"clientes", localField:"id_cliente", foreignField:"id_cliente", as:"cliente"}},
    {$unwind:"$cliente"},
    {$group:{_id:"$cliente.estado_cliente", media_valor_vendas:{$avg:"$total_venda"}}}
])