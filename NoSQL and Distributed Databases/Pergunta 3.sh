db.pedidos.aggregate([
  {
    $group: {
      _id: "$estado_cliente",
      valorMedioVendas: { $avg: "$valor_total" }
    }
  },
  {
    $sort: {
      _id: 1
    }
  }
])