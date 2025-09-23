db.events.aggregate([
  {
    $match: {
      event_type: "purchase"
    }
  },
  {
    $lookup: {
      from: "customers",
      localField: "customer_id",
      foreignField: "_id",
      as: "customer_info"
    }
  },
  {
    $unwind: "$customer_info"
  },
  {
    $group: {
      _id: "$customer_info.address.state",
      average_sale_value: { $avg: "$total_amount" },
      total_sales: { $sum: "$total_amount" },
      number_of_purchases: { $count: {} }
    }
  },
  {
    $sort: {
      average_sale_value: -1
    }
  },
  {
    $project: {
      estado: "$_id",
      valor_medio_vendas: { $round: ["$average_sale_value", 2] },
    }
  }
])