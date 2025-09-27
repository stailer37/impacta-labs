db.pedidos.aggregate([
  {
    $match: {
      data_compra: {
        $gte: new Date(new Date().setDate(new Date().getDate() - 30))
      }
    }
  },
  {
    $unwind: "$itens"
  },
  {
    $group: {
      _id: "$itens.categoria_produto",
      quantidadeTotalVendida: { $sum: "$itens.quantidade" }
    }
  },
  {
    $project: {
        _id: 0,
        categoria: "$_id",
        quantidadeTotalVendida: 1
    }
  }
])