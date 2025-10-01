# Projeto – Estrutura de Collections em MongoDB
## Integrante

Nome Completo   | RA
--------- | ------
Yuri Maia Santana | 2501398

---

## Modelagem das Collections
Neste trabalho, a proposta foi organizar os dados em coleções específicas, ao invés de utilizar uma única coleção centralizada.
Essa escolha garante melhor legibilidade, escalabilidade e flexibilidade para consultas e análises futuras.

As collections utilizadas são as seguintes:

### Clientes
Contém os dados cadastrais dos clientes.

~~~javascript
[
  {
    "id_cliente": 1,
    "nome": "Maria Oliveira",
    "email": "maria.oliveira@email.com",
    "estado": "CE"
  },
  {
    "id_cliente": 2,
    "nome": "Carlos Souza",
    "email": "carlos.souza@email.com",
    "estado": "RN"
  },
  ...
]

~~~
<br>

### Produtos
Responsável por armazenar as informações de cada item disponível para venda.

~~~javascript
[
  {
    "id_produto": 1001,
    "nome": "Geladeira Frost Free",
    "categoria": "Eletrodoméstico",
    "preco": 1899.90
  },
  {
    "id_produto": 1002,
    "nome": "Livro MongoDB Essentials",
    "categoria": "Livro",
    "preco": 89.90
  },
  ...
]
~~~
<br>

### Clicks
Registra os eventos de interação do cliente com os produtos, permitindo análises de interesse e comportamento.

~~~javascript
[
  {
    "id_click": 501,
    "id_cliente": 2,
    "id_produto": 1002,
    "data_hora": "2025-09-21 17:50:00"
  },
  {
    "id_click": 502,
    "id_cliente": 1,
    "id_produto": 1001,
    "data_hora": "2025-09-22 09:30:00"
  },
  ...
]
~~~
<br>

### Vendas
Armazena informações sobre as transações de compra.
Na chave **produtos** é uma matriz de documentos, onde cada um representa um produto na venda.

~~~javascript
[
  {
    "id_venda": 9001,
    "id_cliente": 1,
    "data_hora": "2025-09-06 22:49:23",
    "total": 175.90,
    "itens": [
      { "id_produto": 1001, "quantidade": 1, "preco_unidade": 150.00 },
      { "id_produto": 1002, "quantidade": 1, "preco_unidade": 25.90 }
    ]
  },
  ...
]
~~~

---

## Pergunta da Atividade

### 1. Qual é a média de produtos comprados por cliente?
~~~javascript
db.vendas.aggregate([
    {$unwind:"$produtos"},
    {$group:{_id:"$id_cliente", total_produtos:{$sum:"$produtos.quantidade"}}},
    {$group:{_id:null, media_produtos:{$avg:"$total_produtos"}}}
])
~~~