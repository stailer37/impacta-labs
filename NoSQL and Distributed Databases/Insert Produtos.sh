db.produtos.insertMany([
  {
    "_id": produtoId1,
    "nome": "Livro - Duna",
    "descricao": "Clássico da ficção científica por Frank Herbert.",
    "preco": 65.50,
    "categoria": "livro",
    "sku": "LIV-DUN-001"
  },
  {
    "_id": produtoId2,
    "nome": "Livro - O Guia do Mochileiro das Galáxias",
    "descricao": "Uma aventura cômica pelo espaço por Douglas Adams.",
    "preco": 45.00,
    "categoria": "livro",
    "sku": "LIV-GUI-001"
  },
  {
    "_id": produtoId3,
    "nome": "CD - Pink Floyd: The Dark Side of the Moon",
    "descricao": "Álbum de rock progressivo lançado em 1973.",
    "preco": 55.00,
    "categoria": "CD",
    "sku": "CD-PF-001"
  },
  {
    "_id": produtoId4,
    "nome": "CD - Nirvana: Nevermind",
    "descricao": "Ícone do rock grunge dos anos 90.",
    "preco": 52.90,
    "categoria": "CD",
    "sku": "CD-NIR-001"
  },
  {
    "_id": produtoId5,
    "nome": "Cafeteira Elétrica Mondial Pratic",
    "descricao": "Cafeteira para até 20 xícaras de café.",
    "preco": 129.90,
    "categoria": "eletrodomestico",
    "sku": "ELE-CAF-001"
  }
]);
print("5 produtos inseridos.");