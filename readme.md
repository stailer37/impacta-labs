# 📦 Caso de Estudo – Modelagem NoSQL com MongoDB

## 🎓 MBA em Engenharia de Dados  
**Disciplina:** NoSQL Databases  
**Empresa fictícia:** Amazonas (E-commerce)

---

# 📖 1. Contexto do Problema

A empresa **Amazonas**, do ramo de e-commerce, deseja:

- Monitorar fluxos de cliques dos clientes
- Rastrear produtos comprados
- Responder perguntas analíticas estratégicas

Atualmente vende:

- 📚 Livros  
- 💿 CDs  
- 🍳 Pequenos eletrodomésticos

Com possibilidade de expansão futura.

---

# 🎯 2. Perguntas de Negócio

A modelagem deve permitir responder:

1. Qual é a média de produtos comprados por cliente?
2. Quais são os 20 produtos mais populares por estado dos clientes?
3. Qual é o valor médio das vendas por estado do cliente?
4. Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?

---

# 🏗 3. Decisão Arquitetural: Uma ou Múltiplas Collections?

## ✅ Decisão adotada: **Múltiplas Collections**

Foram criadas 4 collections:

- `customers`
- `products`
- `orders`
- `click_events`

### 🔎 Justificativa Técnica

A decisão foi baseada nos princípios de modelagem orientada a consulta do MongoDB:

> MongoDB Data Modeling Introduction  
https://www.mongodb.com/docs/manual/core/data-modeling-introduction/

Separar as entidades permite:

- Escalabilidade independente
- Melhor indexação
- Redução de documentos gigantes
- Estratégia futura de sharding
- Melhor organização por domínio

---

# 🧠 4. Estratégia de Modelagem Utilizada

## 📦 Orders com Snapshot Parcial (Extended Reference Pattern)

Na collection `orders`, os itens do pedido contêm:

```json
{
  "product_id": "P001",
  "name": "Clean Code",
  "category": "Livro",
  "quantity": 1,
  "unit_price": 120.00
}
```

### Por que repetir `name` e `category`?

#### 1️⃣ Preservação histórica
Se a categoria do produto mudar no futuro, as vendas antigas continuam refletindo o estado original no momento da compra.

#### 2️⃣ Performance
Evita uso frequente de `$lookup`.

#### 3️⃣ Modelo orientado a leitura
Consultas analíticas ficam mais simples e performáticas.

Referência oficial do padrão:

> Extended Reference Pattern  
https://www.mongodb.com/blog/post/building-with-patterns-the-extended-reference-pattern

---

# 📂 5. Estrutura das Collections

## customers
- customer_id
- name
- email
- state
- created_at

## products
- product_id
- name
- category
- price
- created_at

## orders
- order_id
- customer_id
- customer_state
- items (array)
- total_amount
- created_at

## click_events
- event_id
- customer_id
- product_id
- session_id
- event_type
- timestamp

---

# 📊 6. Respostas às Perguntas de Negócio

## 1️⃣ Média de produtos comprados por cliente

```javascript
db.orders.aggregate([
  { $unwind: "$items" },
  {
    $group: {
      _id: "$customer_id",
      total_items: { $sum: "$items.quantity" }
    }
  },
  {
    $group: {
      _id: null,
      media_produtos: { $avg: "$total_items" }
    }
  }
])
```

```javascript
[ { _id: null, media_produtos: 5.25 } ]
```

---

## 2️⃣ 20 produtos mais populares por estado

```javascript
db.orders.aggregate([
  { $unwind: "$items" },
  {
    $group: {
      _id: {
        estado: "$customer_state",
        produto: "$items.name"
      },
      total_vendido: { $sum: "$items.quantity" }
    }
  },
  { $sort: { "_id.estado": 1, total_vendido: -1 } },
  { $limit: 20 }
])
```

```javascript
[
  { _id: { estado: 'BA', produto: 'Produto 2' }, total_vendido: 3 },
  { _id: { estado: 'BA', produto: 'Produto 13' }, total_vendido: 1 },
  { _id: { estado: 'MG', produto: 'Produto 14' }, total_vendido: 5 },
  { _id: { estado: 'MG', produto: 'Produto 7' }, total_vendido: 4 },
  { _id: { estado: 'MG', produto: 'Produto 5' }, total_vendido: 1 },
  { _id: { estado: 'PE', produto: 'Produto 4' }, total_vendido: 4 },
  { _id: { estado: 'PE', produto: 'Produto 12' }, total_vendido: 4 },
  { _id: { estado: 'PE', produto: 'Produto 8' }, total_vendido: 2 },
  { _id: { estado: 'PE', produto: 'Produto 2' }, total_vendido: 1 },
  { _id: { estado: 'PR', produto: 'Produto 12' }, total_vendido: 9 },
  { _id: { estado: 'SC', produto: 'Produto 10' }, total_vendido: 1 },
  { _id: { estado: 'SP', produto: 'Produto 15' }, total_vendido: 4 },
  { _id: { estado: 'SP', produto: 'Produto 9' }, total_vendido: 2 },
  { _id: { estado: 'SP', produto: 'Produto 4' }, total_vendido: 1 }
]

```

---

## 3️⃣ Valor médio das vendas por estado

```javascript
db.orders.aggregate([
  {
    $group: {
      _id: "$customer_state",
      media_vendas: { $avg: "$total_amount" }
    }
  }
])
```

```javascript
[
  { _id: 'MG', media_vendas: 1212.2566666666667 },
  { _id: 'SC', media_vendas: 104.29 },
  { _id: 'SP', media_vendas: 348.22333333333336 },
  { _id: 'PE', media_vendas: 932.97 },
  { _id: 'PR', media_vendas: 578.655 },
  { _id: 'BA', media_vendas: 981.465 }
]

```

---

## 4️⃣ Quantos de cada tipo foram vendidos nos últimos 30 dias

```javascript
db.orders.aggregate([
  {
    $match: {
      created_at: {
        // Gera a string da data de 30 dias atrás (ex: "2026-01-13...")
        $gte: new Date(new Date().setDate(new Date().getDate() - 30)).toISOString()
      }
    }
  },
  { $unwind: "$items" },
  {
    $group: {
      _id: "$items.category",
      total_vendido: { $sum: "$items.quantity" }
    }
  }
])
```

```javascript
[
  { _id: 'livro', total_vendido: 8 },
  { _id: 'eletrodomestico', total_vendido: 18 },
  { _id: 'cd', total_vendido: 16 }
]

```
---

# ⚙ 7. Índices Estratégicos Criados

## orders
- `{ customer_id: 1 }`
- `{ customer_state: 1 }`
- `{ created_at: -1 }`
- `{ "items.product_id": 1 }`

## click_events
- `{ timestamp: -1 }`
- `{ customer_id: 1 }`

Esses índices foram definidos com base nas consultas analíticas exigidas.

---

# 🚀 8. Considerações sobre Escalabilidade

A modelagem suporta:

- Alto volume de pedidos
- Crescimento do catálogo
- Sharding futuro baseado em `customer_state` ou `customer_id`
- Separação de carga transacional (`orders`) e comportamental (`click_events`)

---

# 🏁 9. Conclusão

A decisão por múltiplas collections com denormalização controlada segue boas práticas recomendadas pelo MongoDB, equilibrando:

- Performance
- Escalabilidade
- Governança
- Consistência histórica

A modelagem foi orientada pelas perguntas analíticas do negócio, garantindo que as consultas sejam eficientes sem comprometer a expansão futura da plataforma.

---

# 📚 10. Referências

- Modelagem de dados no MongoDB  
  https://www.mongodb.com/pt-br/docs/manual/data-modeling/

- Melhores práticas para modelagem de dados no MongoDB  
  https://www.mongodb.com/pt-br/docs/manual/data-modeling/best-practices/

- Single vs Multiple Collections in MongoDB  
  https://www.geeksforgeeks.org/mongodb/single-vs-multiple-collections-in-mongodb/

---

# 👥 Integrantes do Grupo

Lucas Amarante Avanço

---


