db.pedidos.aggregate([
  {
    $unwind: "$itens"
  },
  {
    $group: {
      _id: "$cliente_id",
      totalItensComprados: { $sum: "$itens.quantidade" }
    }
  },
  {
    $group: {
      _id: null,
      mediaProdutosPorCliente: { $avg: "$totalItensComprados" }
    }
  }
])