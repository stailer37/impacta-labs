db.pedidos.aggregate([
  {
    // Etapa 1: Desconstrói o array de itens
    $unwind: "$itens"
  },
  {
    // Etapa 2: Agrupa por estado e pelo nome do produto, somando as quantidades vendidas
    $group: {
      _id: {
        estado: "$estado_cliente",
        produto: "$itens.nome_produto"
      },
      totalVendido: { $sum: "$itens.quantidade" }
    }
  },
  {
    // Etapa 3: Ordena os resultados para que os mais vendidos apareçam primeiro em cada estado
    $sort: {
      totalVendido: -1
    }
  },
  {
    // Etapa 4: Agrupa novamente, desta vez apenas por estado, para coletar os produtos ordenados
    $group: {
      _id: "$_id.estado",
      produtosPopulares: {
        $push: { // Cria um array com os produtos e suas contagens
          produto: "$_id.produto",
          quantidade: "$totalVendido"
        }
      }
    }
  },
  {
    // Etapa 5: Usa $project para formatar a saída e pegar apenas os 20 primeiros de cada array
    $project: {
      estado: "$_id",
      _id: 0,
      top20Produtos: { $slice: ["$produtosPopulares", 20] }
    }
  }
])