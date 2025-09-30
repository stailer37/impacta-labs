## Integrantes do Grupo

 - Lucas W Thinen   - RA: 2502344

## Objetivo
Optou-se por responder todas as perguntas por questões de aprendizado

 - Qual é a média de produtos comprados por cliente?
 - Quais são os 20 produtos mais populares por estado dos clientes?
 - Qual é o valor médio das vendas por estado do cliente?
 - Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?

Obs: Para a pergunta "Quais são os 20 produtos mais populares por estado dos clientes?" presumesse popular como aqueles que possuem mais vendas

## Estrutura da única Collection 'sales'
Para a modelagem preferiu-se uma única collection, por ser mais simples e evitar relacionamentos entre collections que pode vir a ser mais custoso para o banco.

A seguir um exemplo da estrutura da collection.
```json
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
```

- `client_state` = Utilizado para filtrar/agrupar por estado 
- `total_price` = Utilizado para compor o cáculo do valor médio de vendas
- `category, quantity` = Ambos de "products" foram utilizados para questões de categorias/tipos de produto e a quantidade para medir a popularidade
- `date_sale` = Utilizado para filtrar/agrupar por data