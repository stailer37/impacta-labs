


# 1. Qual é a média de produtos comprados por cliente?

db.sales.aggregate([
  { $unwind: "$products" },
  {
    $group: {
      _id: "$client_id",
      total_produtos_cliente: { $sum: "$products.quantity" }
    }
  },
  {
    $group: {
      _id: null,
      media_produtos_por_cliente: { $avg: "$total_produtos_cliente" }
    }
  }
]).toArray()


# 2. Quais são os 20 produtos mais populares por estado dos clientes?

db.sales.aggregate([
  { $unwind: "$products" },
  {
    $group: {
      _id: {
        estado: "$client_state",
        produto: "$products.name"
      },
      total_vendido: { $sum: "$products.quantity" }
    }
  },
  {
    $sort: {
      "_id.estado": 1,
      total_vendido: -1
    }
  },
  {
    $group: {
      _id: "$_id.estado",
      produtos: {
        $push: {
          nome: "$_id.produto",
          quantidade: "$total_vendido"
        }
      }
    }
  },
  {
    $project: {
      produtos: { $slice: ["$produtos", 20] }
    }
  }
])


# 3. Qual é o valor médio das vendas por estado do cliente?

db.sales.aggregate([
  {
    $group: {
      _id: "$client_state",
      media_valor_venda: { $avg: "$total_price" }
    },
  },
  {
        $sort: {media_valor_venda: -1}
  }
]).toArray()


# 4. Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?

db.sales.aggregate([
  {
    $match: {
      date_sale: {
        $gte: new Date(Date.now() - 1000 * 60 * 60 * 24 * 30)
      }
    }
  },
  { $unwind: "$products" },
  {
    $group: {
      _id: "$products.category",
      total_vendido: { $sum: "$products.quantity" }
    }
  },
  {
      
        $sort: {total_vendido: -1}
  
  }
]).toArray()


#Caso seja necessário reinserir a collection

db.sales.insertMany([
    
    {
    "id": "S001",
    "client_id": "C101",
    "client_state": "SP",
    "date_sale": ISODate("2025-09-20T10:30:00Z"),
    "products": [
      {
        "product_id": "P001",
        "name": "Livro - Dom Casmurro",
        "category": "Livros",
        "quantity": 1,
        "unit_price": 35.0
      },
      {
        "product_id": "P002",
        "name": "CD - Legião Urbana",
        "category": "CDs",
        "quantity": 2,
        "unit_price": 25.0
      }
    ],
    "total_price": 85.0
  },
  {
    "id": "S002",
    "client_id": "C102",
    "client_state": "RJ",
    "date_sale": ISODate("2025-09-18T15:45:00Z"),
    "products": [
      {
        "product_id": "P003",
        "name": "Liquidificador Oster",
        "category": "Eletrodomésticos",
        "quantity": 1,
        "unit_price": 199.0
      }
    ],
    "total_price": 199.0
  },
  {
    "id": "S003",
    "client_id": "C103",
    "client_state": "MG",
    "date_sale": ISODate("2025-09-17T12:00:00Z"),
    "products": [
      {
        "product_id": "P004",
        "name": "Livro - A Revolução dos Bichos",
        "category": "Livros",
        "quantity": 2,
        "unit_price": 30.0
      }
    ],
    "total_price": 60.0
  },
  {
    "id": "S004",
    "client_id": "C104",
    "client_state": "SP",
    "date_sale": ISODate("2025-09-22T09:30:00Z"),
    "products": [
      {
        "product_id": "P005",
        "name": "CD - Pink Floyd",
        "category": "CDs",
        "quantity": 1,
        "unit_price": 45.0
      },
      {
        "product_id": "P006",
        "name": "Livro - 1984",
        "category": "Livros",
        "quantity": 1,
        "unit_price": 38.0
      }
    ],
    "total_price": 83.0
  },
  {
    "id": "S005",
    "client_id": "C105",
    "client_state": "BA",
    "date_sale": ISODate("2025-09-15T17:10:00Z"),
    "products": [
      {
        "product_id": "P007",
        "name": "Panela Elétrica Arno",
        "category": "Eletrodomésticos",
        "quantity": 1,
        "unit_price": 230.0
      }
    ],
    "total_price": 230.0
  },
  {
    "id": "S006",
    "client_id": "C106",
    "client_state": "RS",
    "date_sale": ISODate("2025-09-19T13:00:00Z"),
    "products": [
      {
        "product_id": "P008",
        "name": "Livro - O Pequeno Príncipe",
        "category": "Livros",
        "quantity": 3,
        "unit_price": 25.0
      }
    ],
    "total_price": 75.0
  },
  {
    "id": "S007",
    "client_id": "C107",
    "client_state": "PE",
    "date_sale": ISODate("2025-09-21T16:20:00Z"),
    "products": [
      {
        "product_id": "P009",
        "name": "CD - Queen Greatest Hits",
        "category": "CDs",
        "quantity": 2,
        "unit_price": 40.0
      }
    ],
    "total_price": 80.0
  },
  {
    "id": "S008",
    "client_id": "C108",
    "client_state": "SP",
    "date_sale": ISODate("2025-09-16T11:15:00Z"),
    "products": [
      {
        "product_id": "P010",
        "name": "Sanduicheira Mondial",
        "category": "Eletrodomésticos",
        "quantity": 1,
        "unit_price": 120.0
      },
      {
        "product_id": "P011",
        "name": "Livro - Sapiens",
        "category": "Livros",
        "quantity": 1,
        "unit_price": 55.0
      }
    ],
    "total_price": 175.0
  },
  {
    "id": "S009",
    "client_id": "C109",
    "client_state": "SC",
    "date_sale": ISODate("2025-09-14T08:40:00Z"),
    "products": [
      {
        "product_id": "P012",
        "name": "CD - Beatles Abbey Road",
        "category": "CDs",
        "quantity": 1,
        "unit_price": 50.0
      }
    ],
    "total_price": 50.0
  },
  {
    "id": "S010",
    "client_id": "C110",
    "client_state": "GO",
    "date_sale": ISODate("2025-09-23T10:10:00Z"),
    "products": [
      {
        "product_id": "P013",
        "name": "Forno Elétrico Philco",
        "category": "Eletrodomésticos",
        "quantity": 1,
        "unit_price": 349.0
      }
    ],
    "total_price": 349.0
  },
  {
    "id": "S011",
    "client_id": "C111",
    "client_state": "SP",
    "date_sale": ISODate("2025-09-24T14:30:00Z"),
    "products": [
      {
        "product_id": "P014",
        "name": "Livro - Harry Potter e a Pedra Filosofal",
        "category": "Livros",
        "quantity": 1,
        "unit_price": 45.0
      },
      {
        "product_id": "P015",
        "name": "CD - Nirvana",
        "category": "CDs",
        "quantity": 1,
        "unit_price": 35.0
      }
    ],
    "total_price": 80.0
  },
  {
    "id": "S012",
    "client_id": "C112",
    "client_state": "MG",
    "date_sale": ISODate("2025-09-13T15:00:00Z"),
    "products": [
      {
        "product_id": "P016",
        "name": "Espremedor de Frutas Electrolux",
        "category": "Eletrodomésticos",
        "quantity": 1,
        "unit_price": 150.0
      }
    ],
    "total_price": 150.0
  },
  {
    "id": "S013",
    "client_id": "C113",
    "client_state": "PR",
    "date_sale": ISODate("2025-09-25T18:45:00Z"),
    "products": [
      {
        "product_id": "P017",
        "name": "Livro - O Hobbit",
        "category": "Livros",
        "quantity": 1,
        "unit_price": 42.0
      }
    ],
    "total_price": 42.0
  },
  {
    "id": "S014",
    "client_id": "C114",
    "client_state": "CE",
    "date_sale": ISODate("2025-09-26T13:30:00Z"),
    "products": [
      {
        "product_id": "P018",
        "name": "CD - Michael Jackson",
        "category": "CDs",
        "quantity": 2,
        "unit_price": 39.0
      }
    ],
    "total_price": 78.0
  },
  {
    "id": "S016",
    "client_id": "C115",
    "client_state": "SP",
    "date_sale": ISODate("2025-09-28T11:30:00Z"),
    "products": [
      {
        "product_id": "P011",
        "name": "Livro - Sapiens",
        "category": "Livros",
        "quantity": 2,
        "unit_price": 55.0
      }
    ],
    "total_price": 110.0
  },
  {
    "id": "S017",
    "client_id": "C116",
    "client_state": "RJ",
    "date_sale": ISODate("2025-09-27T09:20:00Z"),
    "products": [
      {
        "product_id": "P009",
        "name": "CD - Queen Greatest Hits",
        "category": "CDs",
        "quantity": 1,
        "unit_price": 40.0
      },
      {
        "product_id": "P018",
        "name": "CD - Michael Jackson",
        "category": "CDs",
        "quantity": 1,
        "unit_price": 39.0
      }
    ],
    "total_price": 79.0
  },
  {
    "id": "S018",
    "client_id": "C117",
    "client_state": "MG",
    "date_sale": ISODate("2025-09-25T16:10:00Z"),
    "products": [
      {
        "product_id": "P010",
        "name": "Sanduicheira Mondial",
        "category": "Eletrodomésticos",
        "quantity": 1,
        "unit_price": 120.0
      }
    ],
    "total_price": 120.0
  },
  {
    "id": "S019",
    "client_id": "C118",
    "client_state": "BA",
    "date_sale": ISODate("2025-09-24T10:00:00Z"),
    "products": [
      {
        "product_id": "P004",
        "name": "Livro - A Revolução dos Bichos",
        "category": "Livros",
        "quantity": 1,
        "unit_price": 30.0
      },
      {
        "product_id": "P011",
        "name": "Livro - Sapiens",
        "category": "Livros",
        "quantity": 1,
        "unit_price": 55.0
      }
    ],
    "total_price": 85.0
  },
  {
    "id": "S020",
    "client_id": "C119",
    "client_state": "SP",
    "date_sale": ISODate("2025-09-22T14:40:00Z"),
    "products": [
      {
        "product_id": "P003",
        "name": "Liquidificador Oster",
        "category": "Eletrodomésticos",
        "quantity": 1,
        "unit_price": 199.0
      }
    ],
    "total_price": 199.0
  },
  {
    "id": "S021",
    "client_id": "C120",
    "client_state": "RS",
    "date_sale": ISODate("2025-09-21T12:50:00Z"),
    "products": [
      {
        "product_id": "P009",
        "name": "CD - Queen Greatest Hits",
        "category": "CDs",
        "quantity": 3,
        "unit_price": 40.0
      }
    ],
    "total_price": 120.0
  },
  {
    "id": "S022",
    "client_id": "C121",
    "client_state": "SP",
    "date_sale": ISODate("2025-09-20T15:30:00Z"),
    "products": [
      {
        "product_id": "P016",
        "name": "Espremedor de Frutas Electrolux",
        "category": "Eletrodomésticos",
        "quantity": 2,
        "unit_price": 150.0
      }
    ],
    "total_price": 300.0
  },
  {
    "id": "S023",
    "client_id": "C122",
    "client_state": "CE",
    "date_sale": ISODate("2025-09-19T08:10:00Z"),
    "products": [
      {
        "product_id": "P011",
        "name": "Livro - Sapiens",
        "category": "Livros",
        "quantity": 1,
        "unit_price": 55.0
      }
    ],
    "total_price": 55.0
  },
  {
    "id": "S024",
    "client_id": "C123",
    "client_state": "SP",
    "date_sale": ISODate("2025-09-18T17:00:00Z"),
    "products": [
      {
        "product_id": "P005",
        "name": "CD - Pink Floyd",
        "category": "CDs",
        "quantity": 2,
        "unit_price": 45.0
      },
      {
        "product_id": "P007",
        "name": "Panela Elétrica Arno",
        "category": "Eletrodomésticos",
        "quantity": 1,
        "unit_price": 230.0
      }
    ],
    "total_price": 320.0
  },
  {
    "id": "S025",
    "client_id": "C124",
    "client_state": "RJ",
    "date_sale": ISODate("2025-09-17T10:20:00Z"),
    "products": [
      {
        "product_id": "P009",
        "name": "CD - Queen Greatest Hits",
        "category": "CDs",
        "quantity": 1,
        "unit_price": 40.0
      },
      {
        "product_id": "P011",
        "name": "Livro - Sapiens",
        "category": "Livros",
        "quantity": 2,
        "unit_price": 55.0
      }
    ],
    "total_price": 150.0
  }

])
