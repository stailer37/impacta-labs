# Case de Estudo — NoSQL (Documento) · **Amazonas e-commerce**

> **Entrega**: modelagem em MongoDB + eventos de clique/compra + comandos `mongosh` respondendo as 4 perguntas de negócio.

## 👥 Integrante
- **Diogo Meneses Franco - RA: 2202455**

> **Branch criada:** `feat/caso_estudo_grupo_amazonas`

---

## 🧠 Decisões de Modelagem (Documento / MongoDB)

Optei por **múltiplas coleções** em vez de uma só:

- **customers** → cadastro de clientes  
  Campos: `_id`, `name`, `email`, `state`, `created_at`  

- **products** → catálogo de produtos  
  Campos: `_id`, `type` (`book|cd|appliance`), `name`, `price`, `categories`, `attributes` (subdocumento específico por tipo)  

- **orders** → pedidos realizados  
  Campos: `_id`, `customer_id`, `customer_state`, `items[]` (com `product_id`, `product_name`, `category`, `unit_price`, `quantity`), `order_total`, `created_at`, `status`  

- **click_events** → eventos de navegação  
  Campos: `_id`, `ts`, `session_id`, `event_type`, `customer_id`, `state`, `product_id`, `metadata`  

### 🔑 Por que essa modelagem?
- **Desnormalização em `orders`**: já guardamos `customer_state` e os dados do produto no pedido, o que permite responder rapidamente perguntas como “valor médio por estado” sem precisar fazer *join*.  
- **Separação de `click_events`**: cliques têm volume muito maior que pedidos e precisam escalar de forma independente.  
- **Flexibilidade em `products`**: cada tipo de produto (`book`, `cd`, `appliance`) tem atributos próprios em um subdocumento (`isbn13`, `artist`, `brand` etc.), o que facilita expansão futura.  

---

## 🔎 Perguntas de negócio & comandos MongoDB

### 1) Qual é a média de produtos comprados por cliente?
```javascript
db.orders.aggregate([
  { $match: { status: "completed" } },
  { $unwind: "$items" },
  { $group: {
      _id: "$customer_id",
      total_products: { $sum: "$items.quantity" }
    }
  },
  { $group: {
      _id: null,
      avg_products_per_customer: { $avg: "$total_products" }
    }
  }
])
```

### 2) Quais são os 20 produtos mais populares por estado dos clientes?
```javascript
db.orders.aggregate([
  { $match: { status: "completed" } },
  { $unwind: "$items" },
  { $group: {
      _id: {
        state: "$customer_state",
        product_id: "$items.product_id",
        product_name: "$items.product_name"
      },
      qty: { $sum: "$items.quantity" }
    }
  },
  { $setWindowFields: {
      partitionBy: "$_id.state",
      sortBy: { qty: -1 },
      output: { rank: { $rank: {} } }
    }
  },
  { $match: { rank: { $lte: 20 } } },
  { $project: {
      _id: 0,
      state: "$_id.state",
      product_id: "$_id.product_id",
      product_name: "$_id.product_name",
      qty: 1,
      rank: 1
    }
  },
  { $sort: { state: 1, rank: 1 } }
])
```

### 3) Qual é o valor médio das vendas por estado do cliente?
```javascript
db.orders.aggregate([
  { $match: { status: "completed" } },
  { $group: {
      _id: "$customer_state",
      avg_order_value: { $avg: "$order_total" }
    }
  },
  { $project: {
      _id: 0,
      state: "$_id",
      avg_order_value: 1
    }
  },
  { $sort: { state: 1 } }
])
```

### 4) Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?
```javascript
db.orders.aggregate([
  { $match: {
      status: "completed",
      created_at: { $gte: ISODate(new Date(Date.now() - 1000*60*60*24*30).toISOString()) }
    }
  },
  { $unwind: "$items" },
  { $group: {
      _id: "$items.category",
      total_sold: { $sum: "$items.quantity" }
    }
  },
  { $project: {
      _id: 0,
      category: "$_id",
      total_sold: 1
    }
  },
  { $sort: { total_sold: -1 } }
])
```

---

## 📦 Arquivos desta entrega
- `README.md`
- `collection_customers.json`
- `collection_products.json`
- `collection_orders.json`
- `collection_click_events.json`
- `commands_all.sh` (script com as 4 consultas)
