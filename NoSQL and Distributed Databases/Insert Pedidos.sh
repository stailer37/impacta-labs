db.pedidos.insertMany([
  {
    "cliente_id": clienteId1, // Ana de SP
    "data_compra": new Date("2025-09-26T10:15:00Z"), // Ontem
    "estado_cliente": "SP",
    "valor_total": 195.40,
    "itens": [
      { "produto_id": produtoId1, "nome_produto": "Livro - Duna", "categoria_produto": "livro", "quantidade": 1, "preco_unitario": 65.50 },
      { "produto_id": produtoId5, "nome_produto": "Cafeteira Elétrica Mondial Pratic", "categoria_produto": "eletrodomestico", "quantidade": 1, "preco_unitario": 129.90 }
    ]
  },
  {
    "cliente_id": clienteId2, // Bruno do RJ
    "data_compra": new Date("2025-09-17T14:00:00Z"), // 10 dias atrás
    "estado_cliente": "RJ",
    "valor_total": 110.00,
    "itens": [
      { "produto_id": produtoId3, "nome_produto": "CD - Pink Floyd: The Dark Side of the Moon", "categoria_produto": "CD", "quantidade": 2, "preco_unitario": 55.00 }
    ]
  },
  {
    "cliente_id": clienteId3, // Carla de MG
    "data_compra": new Date("2025-08-15T20:30:00Z"), // Mês passado (fora da janela de 30 dias)
    "estado_cliente": "MG",
    "valor_total": 45.00,
    "itens": [
      { "produto_id": produtoId2, "nome_produto": "Livro - O Guia do Mochileiro das Galáxias", "categoria_produto": "livro", "quantidade": 1, "preco_unitario": 45.00 }
    ]
  },
  {
    "cliente_id": clienteId4, // Daniel da BA
    "data_compra": new Date("2025-09-22T11:00:00Z"), // 5 dias atrás
    "estado_cliente": "BA",
    "valor_total": 97.90,
    "itens": [
      { "produto_id": produtoId4, "nome_produto": "CD - Nirvana: Nevermind", "categoria_produto": "CD", "quantidade": 1, "preco_unitario": 52.90 },
      { "produto_id": produtoId2, "nome_produto": "Livro - O Guia do Mochileiro das Galáxias", "categoria_produto": "livro", "quantidade": 1, "preco_unitario": 45.00 }
    ]
  },
  {
    "cliente_id": clienteId1, // Ana de SP (segundo pedido)
    "data_compra": new Date("2025-09-02T18:00:00Z"), // 25 dias atrás
    "estado_cliente": "SP",
    "valor_total": 163.40,
    "itens": [
      { "produto_id": produtoId4, "nome_produto": "CD - Nirvana: Nevermind", "categoria_produto": "CD", "quantidade": 1, "preco_unitario": 52.90 },
      { "produto_id": produtoId2, "nome_produto": "Livro - O Guia do Mochileiro das Galáxias", "categoria_produto": "livro", "quantidade": 1, "preco_unitario": 45.00 },
      { "produto_id": produtoId3, "nome_produto": "CD - Pink Floyd: The Dark Side of the Moon", "categoria_produto": "CD", "quantidade": 1, "preco_unitario": 55.00 }
    ]
  }
]);
print("5 pedidos inseridos.");