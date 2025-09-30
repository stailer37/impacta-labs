// 5) Escolha de uma das perguntas de negócio + comando MongoDB

// "Quais são os 20 produtos mais populares por estado dos clientes?" — definição: popularidade medida por quantidade vendida (soma das quantidades) em pedidos com status completed. Supondo que usamos a coleção orders com items[] e customerSnapshot.address.state.
// Pipeline de agregação — top 20 produtos por estado (retorna state com array topProducts)

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

Observações / extensões:

Se você quer top 20 por estado nos últimos N dias, adicione um $match antes do $unwind com orderDate: { $gte: ISODate("2025-08-31T00:00:00Z") } (por exemplo, últimos 30 dias).

Para incluir product.name, faça um $unwind: "$topProducts", $lookup em products por topProducts.productId, então reconstruir o array por estado.

Se a métrica de popularidade for número de pedidos diferentes que compraram o produto (em vez de unidades vendidas), agrupe também por orderId para contar pedidos distintos.

Exemplo com filtro últimos 30 dias

const start30 = new Date(); start30.setDate(start30.getDate()-30); // ajustar conforme ambiente
db.orders.aggregate([
  { $match: { status: "completed", orderDate: { $gte: ISODate("2025-08-31T00:00:00Z") } } },
  { $unwind: "$items" },
  // ... restante igual ao pipeline anterior
]);

Pipeline MongoDB – Top 20 produtos por estado (com $lookup para nome do produto)

db.orders.aggregate([
  // 1) considerar apenas pedidos completos
  { $match: { status: "completed" } },

  // 2) "explodir" items
  { $unwind: "$items" },

  // 3) agrupar por estado + produto
  { $group: {
      _id: { state: "$customerSnapshot.address.state", productId: "$items.productId" },
      totalSold: { $sum: "$items.quantity" },
      revenue: { $sum: { $multiply: ["$items.quantity", "$items.price"] } }
    }
  },

  // 4) ordenar por quantidade vendida (dentro de cada estado)
  { $sort: { "_id.state": 1, totalSold: -1 } },

  // 5) trazer informações do produto (nome, categoria) via lookup
  { $lookup: {
      from: "products",
      localField: "_id.productId",
      foreignField: "productId",
      as: "productInfo"
    }
  },

  // 6) simplificar productInfo (primeiro item do array)
  { $unwind: "$productInfo" },

  // 7) agrupar de novo por estado e montar lista de produtos
  { $group: {
      _id: "$_id.state",
      products: { $push: {
         productId: "$_id.productId",
         name: "$productInfo.name",
         category: "$productInfo.category",
         totalSold: "$totalSold",
         revenue: "$revenue"
      } }
    }
  },

  // 8) limitar a 20 produtos por estado
  { $project: {
      _id: 0,
      state: "$_id",
      topProducts: { $slice: ["$products", 20] }
    }
  }
]);


Exemplo de saída (mock)

[
  {
    "state": "SP",
    "topProducts": [
      { "productId": "sku-0001", "name": "Aprendendo MongoDB", "category": "books", "totalSold": 250, "revenue": 12475 },
      { "productId": "sku-0042", "name": "Liquidificador X", "category": "kitchen_appliances", "totalSold": 180, "revenue": 35982 }
      // ... até 20 produtos
    ]
  },
  {
    "state": "AM",
    "topProducts": [
      { "productId": "sku-0100", "name": "CD - Amazon Beats", "category": "cds", "totalSold": 90, "revenue": 8991 }
      // ... até 20 produtos
    ]
  }
]






