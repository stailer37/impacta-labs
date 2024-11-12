===========================================Insert PRODUTOS===================================================

db.produtos.insertMany([
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000101"),
    "nome": "Livro de Ficção Científica",
    "tipo": "Livros",
    "preco": 35.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000102"),
    "nome": "Livro de Romance",
    "tipo": "Livros",
    "preco": 42.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000103"),
    "nome": "Livro de Autoajuda",
    "tipo": "Livros",
    "preco": 28.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000104"),
    "nome": "CD de Música Clássica",
    "tipo": "CDs",
    "preco": 15.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000105"),
    "nome": "CD de Rock",
    "tipo": "CDs",
    "preco": 20.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000106"),
    "nome": "CD de Jazz",
    "tipo": "CDs",
    "preco": 18.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000107"),
    "nome": "Mini Processador de Alimentos",
    "tipo": "Pequenos Eletrodomésticos de Cozinha",
    "preco": 80.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000108"),
    "nome": "Liquidificador Compacto",
    "tipo": "Pequenos Eletrodomésticos de Cozinha",
    "preco": 120.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000109"),
    "nome": "Mixer de Mão",
    "tipo": "Pequenos Eletrodomésticos de Cozinha",
    "preco": 90.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000110"),
    "nome": "Cafeteira de Cápsulas",
    "tipo": "Pequenos Eletrodomésticos de Cozinha",
    "preco": 150.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000111"),
    "nome": "Espremedor de Frutas",
    "tipo": "Pequenos Eletrodomésticos de Cozinha",
    "preco": 70.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000112"),
    "nome": "Livro de Mistério",
    "tipo": "Livros",
    "preco": 40.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000113"),
    "nome": "Livro de História",
    "tipo": "Livros",
    "preco": 50.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000114"),
    "nome": "CD de Pop",
    "tipo": "CDs",
    "preco": 25.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000115"),
    "nome": "CD de MPB",
    "tipo": "CDs",
    "preco": 22.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000116"),
    "nome": "Chaleira Elétrica",
    "tipo": "Pequenos Eletrodomésticos de Cozinha",
    "preco": 85.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000117"),
    "nome": "Panela de Arroz Elétrica",
    "tipo": "Pequenos Eletrodomésticos de Cozinha",
    "preco": 130.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000118"),
    "nome": "Torradeira",
    "tipo": "Pequenos Eletrodomésticos de Cozinha",
    "preco": 60.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000119"),
    "nome": "Batedeira Portátil",
    "tipo": "Pequenos Eletrodomésticos de Cozinha",
    "preco": 110.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000120"),
    "nome": "Livro de Biografia",
    "tipo": "Livros",
    "preco": 55.00
  }
]);

===========================================Insert CLIENTES===================================================

db.clientes.insertMany([
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000001"),
    "nome": "Amanda Silva",
    "estado": "SP",
    "idade": 28,
    "genero": "F"
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000002"),
    "nome": "Bruno Costa",
    "estado": "RJ",
    "idade": 35,
    "genero": "M"
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000003"),
    "nome": "Carla Oliveira",
    "estado": "MG",
    "idade": 26,
    "genero": "F"
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000004"),
    "nome": "Diego Santos",
    "estado": "BA",
    "idade": 40,
    "genero": "M"
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000005"),
    "nome": "Eduarda Melo",
    "estado": "PR",
    "idade": 30,
    "genero": "F"
  }
]);

===========================================Insert VENDAS===================================================

db.vendas.insertMany([
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000201"),
    "cliente_id": ObjectId("64b1f5e1c9f0a79f1e000001"),
    "produto_id": ObjectId("64b1f5e1c9f0a79f1e000101"),
    "data_venda": ISODate("2024-11-01"),
    "quantidade": 2,
    "valor_total": 70.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000202"),
    "cliente_id": ObjectId("64b1f5e1c9f0a79f1e000002"),
    "produto_id": ObjectId("64b1f5e1c9f0a79f1e000102"),
    "data_venda": ISODate("2024-11-02"),
    "quantidade": 1,
    "valor_total": 42.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000203"),
    "cliente_id": ObjectId("64b1f5e1c9f0a79f1e000003"),
    "produto_id": ObjectId("64b1f5e1c9f0a79f1e000103"),
    "data_venda": ISODate("2024-11-03"),
    "quantidade": 3,
    "valor_total": 84.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000204"),
    "cliente_id": ObjectId("64b1f5e1c9f0a79f1e000004"),
    "produto_id": ObjectId("64b1f5e1c9f0a79f1e000104"),
    "data_venda": ISODate("2024-11-04"),
    "quantidade": 1,
    "valor_total": 15.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000205"),
    "cliente_id": ObjectId("64b1f5e1c9f0a79f1e000005"),
    "produto_id": ObjectId("64b1f5e1c9f0a79f1e000105"),
    "data_venda": ISODate("2024-11-05"),
    "quantidade": 2,
    "valor_total": 40.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000206"),
    "cliente_id": ObjectId("64b1f5e1c9f0a79f1e000006"),
    "produto_id": ObjectId("64b1f5e1c9f0a79f1e000106"),
    "data_venda": ISODate("2024-11-06"),
    "quantidade": 3,
    "valor_total": 54.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000207"),
    "cliente_id": ObjectId("64b1f5e1c9f0a79f1e000007"),
    "produto_id": ObjectId("64b1f5e1c9f0a79f1e000107"),
    "data_venda": ISODate("2024-11-07"),
    "quantidade": 1,
    "valor_total": 80.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000208"),
    "cliente_id": ObjectId("64b1f5e1c9f0a79f1e000008"),
    "produto_id": ObjectId("64b1f5e1c9f0a79f1e000108"),
    "data_venda": ISODate("2024-11-08"),
    "quantidade": 1,
    "valor_total": 120.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000209"),
    "cliente_id": ObjectId("64b1f5e1c9f0a79f1e000009"),
    "produto_id": ObjectId("64b1f5e1c9f0a79f1e000109"),
    "data_venda": ISODate("2024-11-09"),
    "quantidade": 2,
    "valor_total": 180.00
  },
  {
    "_id": ObjectId("64b1f5e1c9f0a79f1e000210"),
    "cliente_id": ObjectId("64b1f5e1c9f0a79f1e000010"),
    "produto_id": ObjectId("64b1f5e1c9f0a79f1e000110"),
    "data_venda": ISODate("2024-11-10"),
    "quantidade": 1,
    "valor_total": 150.00
  }
]);

==================================Pergunta Qual é o valor médio das vendas por estado do cliente?==========================================

db.vendas.aggregate([
  {
    $lookup: {
      from: "clientes",
      localField: "cliente_id",
      foreignField: "_id",
      as: "cliente_info"
    }
  },
  {
    $unwind: "$cliente_info"
  },
  {
    $group: {
      _id: "$cliente_info.estado",	
      valor_medio_venda: { $avg: "$valor_total" }
    }
  }
])

============================= Resultado ==============================
[
  { _id: 'PR', valor_medio_venda: 40 },
  { _id: 'SP', valor_medio_venda: 70 },
  { _id: 'RJ', valor_medio_venda: 42 },
  { _id: 'MG', valor_medio_venda: 84 },
  { _id: 'BA', valor_medio_venda: 15 }
]