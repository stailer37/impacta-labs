# Grupo 04

## Integrantes
| Nome                              | RA       |
|-----------------------------------|----------|
| Bruno Viggiani                    | xxxxxxx  |
| Ellen                             | xxxxxxx  |
| Guilherme Akira                   | xxxxxxx  |
| Grabriela Ando                    | xxxxxxx  |
| Michel                            | xxxxxxx  |
| Rodrigo Soares da Silva           | 1411295  |


## Pergunta de negócio a ser respondia
- Qual é a média de quantidade de produtos comprados por cliente?

### Exemplo de Documento

```json
[
  {
    "cliente": {
      "cliente_id": "12345",
      "nome": "João Silva",
      "estado": "SP"
    },
    "produto": {
      "produto_id": "001",
      "nome": "Produto A",
      "categoria": "Eletrônicos"
    },
    "data_compra": "2024-11-01T10:15:30Z",
    "quantidade": 1,
    "preco": 299.99
  },
  {
    ...
  }
 ]
``` 

### Explicação dos campos:

- **cliente**: subdocumento com as informações do cliente.
  - **cliente_id**: identificador único do cliente.
  - **nome**: nome do cliente.
  - **estado**: estado do cliente, para análise de popularidade por região.
##### Dados de clientes serão importantes para responder nossa pergunta de cliente, pois precisamos saber quanto cada cliente comprou.

- **produto**: subdocumento com as informações do produto.
  - **produto_id**: identificador único do produto.
  - **nome**: nome do produto.
  - **categoria**: categoria do produto.
##### Dados de produtos serão importantes para responder a outras perguntas que podem surgir, como qual produto mais vende, produtos com melhor e pior margem de lucro.

- **data_compra**: data e hora da compra, para análise temporal das vendas.
- **quantidade**: quantidade de produtos comprados, para agregação de dados de venda.
- **preco**: preço unitário do produto no momento da compra, útil para cálculos de receita (ex: `quantidade * preco`).
##### Informações referentes a compra, como data, preço e quantidade são o mínimo que precisamos em um "negócio online", o campo quantidade será o mais importante nesse momento para responder nossa pergunta de negócio. 

### Comando MongoDB para responder a pergunta de negócio

```javascript
db.compras.aggregate([
  { $group: { _id: "média de quantidade de produtos comprados", total: { $avg: "$quantidade" } } }
])
```

### Resposta a pergunta de negócio
A quantidade média de produtos comprados é de 1.25, ou seja, a maioria dos clientes compra 1 (uma) única unidade de produto.

### Outras Perguntas que podemos responder
- **Quantidade Média de produtos comprados por estado**: MG (1), SP(1), RJ (2)
```javascript
db.compras.aggregate([
  { $group: { _id: "$cliente.estado", total: { $avg: "$quantidade" } } }
])
```
- **Quantidade total de produtos comprados por cliente**: Maria Santos (2), João Silva (1), Carlos Pereira (1), Ana Oliveira (1)
```javascript
db.compras.aggregate([
  { $group: { _id: "$cliente.nome", total: { $sum: "$quantidade" } } }
])
```

- **Quantidade total de produtos comprados**: 5
```javascript
db.compras.aggregate([
  { $group: { _id: "Quantidade total de produtos comprados", total: { $sum: "$quantidade" } } }
])
```