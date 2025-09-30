1) Nome: Luiz Fernando Zanco

2) Recomendações de modelagem (resumo)

Uso recomendado: Múltiplas coleções (híbrido):
products — catálogo canônico (dados do produto).
customers — dados do cliente (inclui endereço/estado).
orders — pedidos/faturas (cada pedido contém array items com productId, quantity, price).
events — stream de eventos de interação (clicks, impressions, add_to_cart, view_product).

Por quê?

Separar catálogo e eventos evita duplicação e facilita atualizações (preço/descrição mudam mais que histórico de compras).
orders em documento com items[] permite agregações (unwind) eficientes para métricas de vendas e receita.
events armazena cliques em alta taxa (append-only), ideal para análises de comportamento e sessões.
Facilita índices específicos (e.g., index em orders.customer.address.state e orders.orderDate, e em events.userId, events.timestamp).

3) Campos sugeridos por coleção (detalhado)
products (catálogo)

{
  "productId": "sku-0001",        // string único e estático (não usar _id só por ObjectId)
  "sku": "AMZ-LIV-0001",
  "name": "Aprendendo MongoDB",
  "category": "books",            // category hierárquica: "books", "cds", "kitchen_appliances" etc.
  "subcategory": "programming",
  "brand": "Editora X",
  "price": 49.90,                 // preço corrente (para catálogo); histórico de preço pode ficar em outra coleção se necessário
  "currency": "BRL",
  "attributes": { "pages": 320, "format": "paperback" },
  "tags": ["bestseller","mongodb"],
  "variants": [],                 // se houver (cor, voltagem)
  "stock": 120,
  "createdAt": ISODate(...),
  "updatedAt": ISODate(...),
  "discontinued": false
}


Por que esses campos? nome/sku/category/price são essenciais para análises; attributes e variants permitem expansão para outros tipos de produto; discontinued permite marcar e filtrar produtos antigos.

customers:

{
  "customerId": "cust_12345",
  "email": "ana@ex.com",
  "name": "Ana Silva",
  "address": {
    "street": "...",
    "city": "Manaus",
    "state": "AM",
    "postalCode": "69000-000",
    "country": "BR"
  },
  "createdAt": ISODate(...),
  "profile": { "birthYear": 1985, "gender": "F" },
  "lifetimeValue": 1234.50
}


Por que: estado é essencial para várias das perguntas do negócio; manter customer separado facilita joins quando necessário.

orders:

Documento por pedido:

{
  "_id": ObjectId(...),
  "orderId": "ord_20250930_00001",
  "customerId": "cust_12345",
  "customerSnapshot": {
    "name": "Ana Silva",
    "address": { "city":"Manaus", "state":"AM" }  // snapshot para consistência histórica
  },
  "items": [
    { "productId": "sku-0001", "quantity": 2, "price": 49.90, "currency":"BRL" },
    { "productId": "sku-0042", "quantity": 1, "price": 199.90, "currency":"BRL" }
  ],
  "subtotal": 299.7,
  "shipping": 15.0,
  "tax": 0,
  "total": 314.7,
  "status": "completed", // pending, canceled, completed
  "orderDate": ISODate("2025-09-25T13:12:00Z"),
  "paymentMethod": "credit_card"
}


Por que: items[] permite unwind e agregação por produto; customerSnapshot preserva estado do cliente no momento do pedido (útil para mudanças posteriores no cadastro).

events (clickstream)

Linha por evento (append-only):


{
  "_id": ObjectId(...),
  "eventId": "evt_abc123",
  "type": "product_click", // product_view, add_to_cart, checkout_start, purchase_event (ou usar orders para compra)
  "userId": "cust_12345",  // pode ser null para guest
  "sessionId": "sess_789",
  "productId": "sku-0001",
  "page": "/product/sku-0001",
  "referrer": "/search?q=mongo",
  "timestamp": ISODate(...),
  "metadata": { "device":"mobile", "browser":"Chrome" }
}

Por que: registros leves e padronizados; index em type, userId, timestamp para análises por sessão/usuário.

4) Eventos sistêmicos em JSON (exemplos práticos)

a) Evento de clique (clickstream)

{
  "eventId": "evt_20250930_0001",
  "type": "product_click",
  "timestamp": "2025-09-30T14:05:12Z",
  "userId": "cust_98765",
  "sessionId": "sess_XYZ_111",
  "productId": "sku-0001",
  "page": "/product/sku-0001",
  "metadata": { "device": "mobile", "ip": "200.1.2.3" }
}

b) Evento de compra / order (no orders collection — exemplo de documento)

{
  "orderId": "ord_20250929_9001",
  "customerId": "cust_98765",
  "customerSnapshot": { "name": "João", "address": { "state": "SP", "city":"São Paulo" } },
  "items": [
    { "productId": "sku-0001", "quantity": 1, "price": 49.90 },
    { "productId": "sku-0100", "quantity": 2, "price": 79.90 }
  ],
  "subtotal": 209.70,
  "total": 209.70,
  "status": "completed",
  "orderDate": "2025-09-29T18:20:00Z",
  "paymentMethod": "boleto"
}

c) Evento de criação de produto (audit)

{
  "eventId": "evt_product_created_001",
  "type": "product_created",
  "timestamp": "2025-01-15T09:00:00Z",
  "product": {
    "productId": "sku-1234",
    "name": "Liquidificador X",
    "category": "kitchen_appliances",
    "price": 299.90
  },
  "createdBy": "catalog_admin"
}


5) Índices recomendados (alta prioridade)

orders: { orderDate: 1 }, { "customerSnapshot.address.state": 1, orderDate: -1 }, { "items.productId": 1 }

events: { type: 1, timestamp: -1 }, { userId: 1, timestamp: -1 }

products: { productId: 1 }, { category: 1, name: 1 }
Esses índices aceleram consultas por estado, agregações por produto e filtros por período.

6) Escolha de uma das perguntas de negócio + comando MongoDB

Você pediu para escolher uma das quatro perguntas e gerar um comando MongoDB. Vou responder a esta:

"Quais são os 20 produtos mais populares por estado dos clientes?" — definição: popularidade medida por quantidade vendida (soma das quantidades) em pedidos com status completed. Supondo que usamos a coleção orders com items[] e customerSnapshot.address.state.


Pipeline de agregação — top 20 produtos por estado (retorna state com array topProducts)

db.orders.aggregate([
  // 1) considerar apenas pedidos completos
  { $match: { status: "completed" } },

  // 2) "explodir" items para agregar por produto
  { $unwind: "$items" },

  // 3) agrupar por estado + productId somando quantidade vendida
  { $group: {
      _id: { state: "$customerSnapshot.address.state", productId: "$items.productId" },
      totalSold: { $sum: "$items.quantity" },
      revenue: { $sum: { $multiply: ["$items.quantity", "$items.price"] } }
    }
  },

  // 4) ordenar por state e por quantidade vendida desc (ajuda no grouping seguinte)
  { $sort: { "_id.state": 1, "totalSold": -1 } },

  // 5) agrupar por estado e montar uma lista ordenada de produtos
  { $group: {
      _id: "$_id.state",
      products: { $push: {
         productId: "$_id.productId",
         totalSold: "$totalSold",
         revenue: "$revenue"
      } }
    }
  },

  // 6) manter só top 20 por estado
  { $project: {
      _id: 0,
      state: "$_id",
      topProducts: { $slice: ["$products", 20] }
    }
  }

  // Opcional: para trazer nome do produto (join com products), descomente e use $unwind/$lookup/$group adicional
]);


Pipeline MongoDB – Top 20 produtos por estado (com $lookup para nome do produto)








