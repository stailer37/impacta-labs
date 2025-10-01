# Qual é o valor médio das vendas por estado do cliente?

db.orders.aggregate([
  {
    $group: {
      _id: "$customer_state",
      avg_sales: { $avg: "$payment.value" },
      total_orders: { $sum: 1 }
    }
  },
  {
    $project: {
      _id: 0,
      state: "$_id",
      avg_sales: { $round: ["$avg_sales", 2] },
      total_orders: 1
    }
  },
  { $sort: { state: 1 } }
])


#Quais são os 20 produtos mais populares por estado dos clientes?

db.orders.aggregate([
  { $unwind: "$items" },
  {
    $group: {
      _id: {
        state: "$customer_state",
        product_id: "$items.product_id",
        sku: "$items.sku",
        name: "$items.name"
      },
      total_qty: { $sum: "$items.qty" }
    }
  },
  { $sort: { "_id.state": 1, total_qty: -1 } },
  {
    $group: {
      _id: "$_id.state",
      produtos: {
        $push: {
          product_id: "$_id.product_id",
          sku: "$_id.sku",
          name: "$_id.name",
          total_qty: "$total_qty"
        }
      }
    }
  },
  { $project: { top20: { $slice: ["$produtos", 20] } } }
])


# Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?
db.orders.aggregate([
  {
    $match: {
      created_at: { $gte: new Date(Date.now() - 30*24*60*60*1000) },
      status: { $in: ["paid", "shipped"] }
    }
  },
  {
    $addFields: {
      items: {
        $map: {
          input: "$items",
          as: "it",
          in: {
            $mergeObjects: [
              "$$it",
              { qty: { $toDouble: "$$it.qty" } }
            ]
          }
        }
      }
    }
  },
  { $unwind: { path: "$items", preserveNullAndEmptyArrays: false } },
  {
    $group: {
      _id: "$items.category",        // "book" | "cd" | "kitchen_appliance"
      total_qty: { $sum: "$items.qty" }
    }
  },
  { $project: { _id: 0, category: "$_id", total_qty: 1 } },
  { $sort: { total_qty: -1, category: 1 } }
]);

