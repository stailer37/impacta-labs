# Integrantes

Nome   | RA
--------- | ------
Bruno Lima de Santana | 2102097
Diogo Antonio da Silva | 2500521

---

# Estrutura das Collections
Para esse projeto foi optado por múltiplas collections com o intuito de ter uma abordagem mais flexível e eficiente, evitando de criar uma única collection grande e complexa.

As collections foram divididas da seguinte forma:

## Clientes
Armazena todos os dados dos clientes cadastrados.

~~~javascript
[
    {
        "id_cliente": 0, // Identificador do cliente
        "nome_cliente": "nome", // Nome cadastrado do cliente
        "email_cliente": "nome@email.com", // Email cadastrado do cliente
        "estado_cliente": "SP" // Estado cadastrado do cliente
    },
    ...
]
~~~
<br>

## Produtos
Armazena informações detalhadas dos produtos.

~~~javascript
[
    {
        "id_produto": 455, // Identificador do produto
        "nome_produto": "Produto", // Nome do produto
        "categoria_produto": "categoria", // Categoria do produto (DVD, CD, Livro, Eletrodoméstico)
        "preco_produto": 99.99 // Valor do produto
    },
    ...
]
~~~
<br>

## Clicks
Essa collection foi pensada para armazenar os eventos de cliques dos clientes, tornando possível analisar possíveis produtos de interesse.

~~~javascript
[
    {
        "id_click": 23154621, // Identificador do evento
        "id_cliente": 12, // Idetificador do cliente que realizou o evento
        "id_produto": 455, // identificador do produto visualizado
        "timestamp": "2025-09-21 17:50:00" // Data e hora do evento
    },
    ...
]
~~~
<br>

## Vendas
Armazena informações sobre as transações de compra.
Na chave **produtos** é uma matriz de documentos, onde cada um representa um produto na venda.

~~~javascript
[
    {
        "id_venda": 2345, // Identificador da venda
        "id_cliente": 6, // Identificador do cliente que comprou
        "timestamp_venda": "2025-09-06 22:49:23", // Data e hora da venda
        "total_venda": 175.90, // Valor total da venda
        "produtos": [ // Matriz com todos os produtos comprados
            {
                "id_produto": 254, // Identificador do produto
                "quantidade": 1, // Quantidade de unidades comprada
                "preco_unidade": 150.00 // Valor por unidade do produto
            },
            {
                "id_produto": 154,
                "quantidade": 1,
                "preco_unidade": 25.90
            }
        ]
    },
    ...
]
~~~

---

# Perguntas escolhidas
Para essa atividade foram escolhidas duas das quatro perguntas disponibilizadas na atividade

## 1. Qual é a média de produtos comprados por cliente?
~~~javascript
db.vendas.aggregate([
    {$unwind:"$produtos"}, // Desconstrói a matriz 'products'
    {$group:{ 
        _id:"$id_cliente", 
        q_produtos_comprados:{$sum:"$produtos.quantidade"}
        }}, // Agrupa os documentos por cliente e soma a quantidade de produtos
    {$group:{ 
        _id:null, 
        media_produtos:{$avg:"$q_produtos_comprados"}
        }} // Calcula a média de produtos comprados por clientes diferentes
])
~~~
<br>

## 2. Qual é o valor médio das vendas por estado do cliente?
~~~javascript
db.vendas.aggregate([
    {$lookup:{
        from:"clientes", 
        localField:"id_cliente", 
        foreignField:"id_cliente", 
        as:"cliente"
        }}, // Realiza uma junção com a collection clientes
    {$unwind:"$cliente"}, // Desconstrói a matriz criada
    {$group:{
        _id:"$cliente.estado_cliente", 
        media_valor_vendas:{$avg:"$total_venda"}
        }} // Agrupa por estado e depois calcula a média
])
~~~