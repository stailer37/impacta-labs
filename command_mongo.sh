db.compras.aggregate([
  {
    $group: {
      _id: {
        estado: "$estado",
        produto: "$produto.nome"
      },
      total_vendas: { $sum: "$quantidade" }
    }
  },
  { $sort: { "_id.estado": 1, total_vendas: -1 } },
  {
    $group: {
      _id: "$_id.estado",
      produtos: {
        $push: {
          nome: "$_id.produto",
          total: "$total_vendas"
        }
      }
    }
  },
  {
    $project: {
      estado: "$_id",
      _id: 0,
      top_20_produtos: { $slice: ["$produtos", 20] }
    }
  }
]).pretty()
