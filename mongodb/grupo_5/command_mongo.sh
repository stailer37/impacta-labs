//COMANDOS

//INSERIR OS DADOS NA COLLECTION
db.compras.insertMany(
[
  {
    "id_cliente": 1,
    "nome_cliente": "João Francisco",
    "data_compra": "2024-10-20T10:15:00.000Z",
    "produto": "Senhor dos Anéis",
    "quantidade": 1,
    "categoria_produto": 1,
    "valor_produto": 100.00
  },
  {
    "id_cliente": 1,
    "nome_cliente": "João Francisco",
    "data_compra": "2024-10-18T14:45:00.000Z",
    "produto": "Harry Potter e a Pedra Filosofal",
    "quantidade": 2,
    "categoria_produto": 1,
    "valor_produto": 80.00
  },
  {
    "id_cliente": 1,
    "nome_cliente": "João Francisco",
    "data_compra": "2024-10-15T11:30:00.000Z",
    "produto": "O Código Da Vinci",
    "quantidade": 1,
    "categoria_produto": 1,
    "valor_produto": 60.00
  },
  {
    "id_cliente": 1,
    "nome_cliente": "João Francisco",
    "data_compra": "2024-10-22T09:00:00.000Z",
    "produto": "CD de Sertanejo",
    "quantidade": 3,
    "categoria_produto": 2,
    "valor_produto": 25.00
  },
  {
    "id_cliente": 1,
    "nome_cliente": "João Francisco",
    "data_compra": "2024-10-19T16:00:00.000Z",
    "produto": "CD de Rock",
    "quantidade": 1,
    "categoria_produto": 2,
    "valor_produto": 40.00
  },
  {
    "id_cliente": 1,
    "nome_cliente": "João Francisco",
    "data_compra": "2024-10-10T12:30:00.000Z",
    "produto": "Ferro de Passar Roupas",
    "quantidade": 1,
    "categoria_produto": 3,
    "valor_produto": 120.00
  },
  {
    "id_cliente": 2,
    "nome_cliente": "Maria Oliveira",
    "data_compra": "2024-10-18T13:00:00.000Z",
    "produto": "O Hobbit",
    "quantidade": 1,
    "categoria_produto": 1,
    "valor_produto": 50.00
  },
  {
    "id_cliente": 2,
    "nome_cliente": "Maria Oliveira",
    "data_compra": "2024-10-16T10:30:00.000Z",
    "produto": "Lendo no Escuro",
    "quantidade": 2,
    "categoria_produto": 1,
    "valor_produto": 55.00
  },
  {
    "id_cliente": 2,
    "nome_cliente": "Maria Oliveira",
    "data_compra": "2024-10-12T15:30:00.000Z",
    "produto": "CD de Jazz",
    "quantidade": 1,
    "categoria_produto": 2,
    "valor_produto": 45.00
  },
  {
    "id_cliente": 2,
    "nome_cliente": "Maria Oliveira",
    "data_compra": "2024-10-14T09:00:00.000Z",
    "produto": "Microondas",
    "quantidade": 1,
    "categoria_produto": 3,
    "valor_produto": 150.00
  },
  {
    "id_cliente": 2,
    "nome_cliente": "Maria Oliveira",
    "data_compra": "2024-10-20T11:00:00.000Z",
    "produto": "CD de MPB",
    "quantidade": 3,
    "categoria_produto": 2,
    "valor_produto": 30.00
  },
  {
    "id_cliente": 2,
    "nome_cliente": "Maria Oliveira",
    "data_compra": "2024-10-17T16:15:00.000Z",
    "produto": "Liquidificador",
    "quantidade": 1,
    "categoria_produto": 3,
    "valor_produto": 180.00
  },
  {
    "id_cliente": 3,
    "nome_cliente": "Carlos Alberto",
    "data_compra": "2024-10-21T08:45:00.000Z",
    "produto": "O Príncipe",
    "quantidade": 2,
    "categoria_produto": 1,
    "valor_produto": 45.00
  },
  {
    "id_cliente": 3,
    "nome_cliente": "Carlos Alberto",
    "data_compra": "2024-10-19T14:30:00.000Z",
    "produto": "A Revolução dos Bichos",
    "quantidade": 1,
    "categoria_produto": 1,
    "valor_produto": 30.00
  },
  {
    "id_cliente": 3,
    "nome_cliente": "Carlos Alberto",
    "data_compra": "2024-10-15T12:00:00.000Z",
    "produto": "CD de Música Clássica",
    "quantidade": 1,
    "categoria_produto": 2,
    "valor_produto": 60.00
  },
  {
    "id_cliente": 3,
    "nome_cliente": "Carlos Alberto",
    "data_compra": "2024-10-14T13:00:00.000Z",
    "produto": "Cafeteira Elétrica",
    "quantidade": 1,
    "categoria_produto": 3,
    "valor_produto": 130.00
  },
  {
    "id_cliente": 3,
    "nome_cliente": "Carlos Alberto",
    "data_compra": "2024-10-10T17:00:00.000Z",
    "produto": "Refrigerador",
    "quantidade": 1,
    "categoria_produto": 3,
    "valor_produto": 900.00
  },
  {
    "id_cliente": 3,
    "nome_cliente": "Carlos Alberto",
    "data_compra": "2024-10-20T18:00:00.000Z",
    "produto": "CD de Samba",
    "quantidade": 2,
    "categoria_produto": 2,
    "valor_produto": 50.00
  }
]

);


//PERGUNTA: Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?

//RESPOSTA:

db.compras.aggregate([
  {
    $match: {
      data_compra: { 
        $gte: new Date(new Date().getTime() - 30 * 24 * 60 * 60 * 1000).toISOString() 
      }
    }
  },
  {
    $group: {
      _id: "$categoria_produto",                     
      totalVendido: { $sum: "$quantidade" }          
    }
  },
  {
    $project: {
      _id: 0,                                        
      categoria_produto: "$_id",                     
      totalVendido: 1                                
    }
  }
])

