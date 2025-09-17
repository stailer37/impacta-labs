//COMANDOS

//INSERIR OS DADOS NA COLLECTION
db.pedido_venda.insertMany([
    {
        "id_pedido": 1,
        "id_cliente": 1,
        "dthr_pedido": ISODate("2025-07-07T23:09:13Z"),
        "produtos": [
            {
                "produto_id": 1,
                "nome": "Thriller",
                "categoria": "cd",
                "quantidade": 2,
                "preco_unitario": 539.42
            },
            {
                "produto_id": 2,
                "nome": "Dom Casmurro",
                "categoria": "livro",
                "quantidade": 1,
                "preco_unitario": 17.76
            }
        ],
        "valor_total": 1096.96,
        "entrega": {
            "estado": "RJ"
        }
    },
    {
        "id_pedido": 2,
        "id_cliente": 3,
        "dthr_pedido": ISODate("2025-07-15T10:19:41Z"),
        "produtos": [
            {
                "produto_id": 3,
                "nome": "Micro-ondas",
                "categoria": "eletrodoméstico de cozinha",
                "quantidade": 1,
                "preco_unitario": 529
            },
            {
                "produto_id": 5,
                "nome": "O Pequeno Príncipe",
                "categoria": "livro",
                "quantidade": 1,
                "preco_unitario": 13.90
            },
            {
                "produto_id": 1,
                "nome": "Thriller",
                "categoria": "cd",
                "quantidade": 1,
                "preco_unitario": 539.42
            }
        ],
        "valor_total": 1082.32,
        "entrega": {
            "estado": "MG"
        }
    },
    {
        "id_pedido": 3,
        "id_cliente": 1,
        "dthr_pedido": ISODate("2025-07-15T20:27:55Z"),
        "produtos": [
            {
                "produto_id": 1,
                "nome": "Thriller",
                "categoria": "cd",
                "quantidade": 2,
                "preco_unitario": 539.42
            },
            {
                "produto_id": 4,
                "nome": "Balaio do Amor",
                "categoria": "cd",
                "quantidade": 3,
                "preco_unitario": 260.99
            }
        ],
        "valor_total": 1861.81,
        "entrega": {
            "estado": "RJ"
        }
    },
    {
        "id_pedido": 4,
        "id_cliente": 3,
        "dthr_pedido": ISODate("2025-07-17T15:48:17Z"),
        "produtos": [
            {
                "produto_id": 6,
                "nome": "Cefeteira Elétrica",
                "categoria": "eletrodoméstico de cozinha",
                "quantidade": 1,
                "preco_unitario": 238.9
            }
        ],
        "valor_total": 238.9,
        "entrega": {
            "estado": "MG"
        }
    },
    {
        "id_pedido": 5,
        "id_cliente": 1,
        "dthr_pedido": ISODate("2025-07-21T03:08:13Z"),
        "produtos": [
            {
                "produto_id": 5,
                "nome": "O Pequeno Príncipe",
                "categoria": "livro",
                "quantidade": 10,
                "preco_unitario": 13.9
            },
            {
                "produto_id": 2,
                "nome": "Dom Casmurro",
                "categoria": "livro",
                "quantidade": 10,
                "preco_unitario": 17.76
            }
        ],
        "valor_total": 316.6,
        "entrega": {
            "estado": "RJ"
        }
    },
    {
        "id_pedido": 6,
        "id_cliente": 1,
        "dthr_pedido": ISODate("2025-07-28T02:34:41Z"),
        "produtos": [
            {
                "produto_id": 4,
                "nome": "Balaio do Amor",
                "categoria": "cd",
                "quantidade": 1,
                "preco_unitario": 260.99
            },
            {
                "produto_id": 5,
                "nome": "O Pequeno Príncipe",
                "categoria": "livro",
                "quantidade": 1,
                "preco_unitario": 13.9
            }
        ],
        "valor_total": 274.89,
        "entrega": {
            "estado": "RJ"
        }
    },
    {
        "id_pedido": 7,
        "id_cliente": 2,
        "dthr_pedido": ISODate("2025-07-28T04:12:27Z"),
        "produtos": [
            {
                "produto_id": 2,
                "nome": "Dom Casmurro",
                "categoria": "livro",
                "quantidade": 1,
                "preco_unitario": 17.76
            }
        ],
        "valor_total": 17.76,
        "entrega": {
            "estado": "SP"
        }
    },
    {
        "id_pedido": 8,
        "id_cliente": 3,
        "dthr_pedido": ISODate("2025-08-05T19:21:11Z"),
        "produtos": [
            {
                "produto_id": 5,
                "nome": "O Pequeno Príncipe",
                "categoria": "livro",
                "quantidade": 1,
                "preco_unitario": 13.9
            }
        ],
        "valor_total": 13.9,
        "entrega": {
            "estado": "MG"
        }
    },
    {
        "id_pedido": 9,
        "id_cliente": 3,
        "dthr_pedido": ISODate("2025-08-05T19:56:40Z"),
        "produtos": [
            {
                "produto_id": 1,
                "nome": "Thriller",
                "categoria": "cd",
                "quantidade": 2,
                "preco_unitario": 539.42
            }
        ],
        "valor_total": 539.42,
        "entrega": {
            "estado": "MG"
        }
    },
    {
        "id_pedido": 10,
        "id_cliente": 1,
        "dthr_pedido": ISODate("2025-08-10T06:43:17Z"),
        "produtos": [
            {
                "produto_id": 3,
                "nome": "Micro-ondas",
                "categoria": "eletrodoméstico de cozinha",
                "quantidade": 1,
                "preco_unitario": 529
            },
            {
                "produto_id": 6,
                "nome": "Cafeteira Elétrica",
                "categoria": "eletrodoméstico de cozinha",
                "quantidade": 1,
                "preco_unitario": 238.9
            }
        ],
        "valor_total": 767.9,
        "entrega": {
            "estado": "RJ"
        }
    },
    {
        "id_pedido": 11,
        "id_cliente": 1,
        "dthr_pedido": ISODate("2025-08-11T09:11:46Z"),
        "produtos": [
            {
                "produto_id": 5,
                "nome": "O Pequeno Príncipe",
                "categoria": "livro",
                "quantidade": 1,
                "preco_unitario": 13.9
            },
            {
                "produto_id": 2,
                "nome": "Dom Casmurro",
                "categoria": "livro",
                "quantidade": 1,
                "preco_unitario": 17.76
            },
            {
                "produto_id": 6,
                "nome": "Cafeteira Elétrica",
                "categoria": "eletrodoméstico de cozinha",
                "quantidade": 1,
                "preco_unitario": 238.90
            }
        ],
        "valor_total": 270.56,
        "entrega": {
            "estado": "RJ"
        }
    },
    {
        "id_pedido": 12,
        "id_cliente": 3,
        "dthr_pedido": ISODate("2025-08-12T01:56:49Z"),
        "produtos": [
            {
                "produto_id": 4,
                "nome": "Bailaio de Amor",
                "categoria": "cd",
                "quantidade": 1,
                "preco_unitario": 260.99
            },
            {
                "produto_id": 5,
                "nome": "O Pequeno Príncipe",
                "categoria": "livro",
                "quantidade": 1,
                "preco_unitario": 13.90
            }
        ],
        "valor_total": 274.89,
        "entrega": {
            "estado": "MG"
        }
    },
    {
        "id_pedido": 13,
        "id_cliente": 1,
        "dthr_pedido": ISODate("2025-08-12T07:17:45Z"),
        "produtos": [
            {
                "produto_id": 4,
                "nome": "Balaio do Amor",
                "categoria": "cd",
                "quantidade": 2,
                "preco_unitario": 260.99
            }
        ],
        "valor_total": 521.98,
        "entrega": {
            "estado": "RJ"
        }
    },
    {
        "id_pedido": 14,
        "id_cliente": 1,
        "dthr_pedido": ISODate("2025-08-18T14:23:36Z"),
        "produtos": [
            {
                "produto_id": 5,
                "nome": "O Pequeno Príncipe",
                "categoria": "livro",
                "quantidade": 1,
                "preco_unitario": 13.9
            }
        ],
        "valor_total": 13.9,
        "entrega": {
            "estado": "RJ"
        }
    },
    {
        "id_pedido": 15,
        "id_cliente": 2,
        "dthr_pedido": ISODate("2025-08-19T22:38:18Z"),
        "produtos": [
            {
                "produto_id": 1,
                "nome": "Thriller",
                "categoria": "cd",
                "quantidade": 2,
                "preco_unitario": 539.42
            },
            {
                "produto_id": 3,
                "nome": "Micro-ondas",
                "categoria": "eletrodoméstico de cozinha",
                "quantidade": 1,
                "preco_unitario": 529
            }
        ],
        "valor_total": 1068.42,
        "entrega": {
            "estado": "SP"
        }
    }
]);

//-----------------------------------------------------------------------------------
//PERGUNTA: Qual é a média de produtos comprados por cliente?

//RESPOSTA:
db.pedido_venda.aggregate([
    {
        $unwind: "$produtos" // Primeiro desfaz o array de produtos
    },
    {
        $group: {
        _id: {
            cliente: "$id_cliente",
            pedido: "$id_pedido" // Agrupa por cliente E por pedido
        },
        totalPorPedido: { $sum: "$produtos.quantidade" } // Soma o total por pedido
        }
    },
    {
        $group: {
        _id: "$_id.cliente",
        mediaProdutosPorPedido: { $avg: "$totalPorPedido" } // Calcula a média
        }
    },
    {
        $sort: { _id: 1 } // Ordena os dados
    }
]);

//-----------------------------------------------------------------------------------
//PERGUNTA: Quais são os 20 produtos mais populares por estado dos clientes?

//RESPOSTA:
db.pedido_venda.aggregate([
    { $unwind: "$entrega" }, // Primeiro desfaz o array de entrega
    { $unwind: "$produtos" }, // Desfaz o array de produtos
    {
        $group: {
        _id: {
            estado: "$entrega.estado",
            produto: "$produtos.nome"
        },
        quantidadeVendida: { $sum: "$produtos.quantidade" } // Soma a quantidade vendida
        }
    },
    {
        $group: {
        _id: "$_id.estado",
        produtos: {
            $push: {
                nome: "$_id.produto",
                quantidadeVendida: "$quantidadeVendida"    
            }
        }
        }
    },
{ // Para ordenar os produtos dentro dos estados
  $addFields: {
    produtos: {
        $slice: [
        {
            $sortArray: {
            input: "$produtos",
            sortBy: { quantidadeVendida: -1 } // Descendente
            }
        },
        20 // Pegar os primeiros 20 produtos
        ]
    }
  }
}
]);

//-----------------------------------------------------------------------------------
//PERGUNTA: Qual é o valor médio das vendas por estado do cliente?

//RESPOSTA:
db.pedido_venda.aggregate([
    {
        $unwind: "$entrega" // Primeiro desfaz o array de entrega
    },
    {
        $group: {
        _id: {
            estado: "$entrega.estado",
            pedido: "$id_pedido"
        },
        valorPedido: { $first: "$valor_total" } // Pega o valor total do pedido
        }
    },
    {
        $group: {
        _id: "$_id.estado",
        mediaValorPorPedido: { $avg: "$valorPedido" } // Calcula a média
        }
    },
    {
        $sort: { _id: 1 } // Ordena os dados
    }
]);

//-----------------------------------------------------------------------------------
//PERGUNTA: Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?

//RESPOSTA:
db.pedido_venda.aggregate([
    {
        $match: {dthr_pedido: {$gte: new Date(ISODate().getTime() - 30 * 24 * 60 * 60 * 1000)} }
    },
    {
        $unwind: "$produtos" // Primeiro desfaz o array de produtos
    },
    {
        $group: {
        _id: {
            categoria: "$produtos.categoria",
            pedido: "$id_pedido"
        },
        quantidadeVendida: { $sum: "$produtos.quantidade" } // Soma quantidade vendida
        }
    },
    {
        $group: {
        _id: "$_id.categoria",
        totalQuantidadeVendida: { $sum: "$quantidadeVendida" } // Soma o total
        }
    },
    {
        $sort: { _id: 1 } // Ordena os dados
    }
]);