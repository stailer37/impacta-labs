db.transactions.aggregate([
  // 1. Desanexa o array de produtos (embedding)
  {
    $unwind: "$products"
  },
  
  // 2. Agrupa por Estado e SKU do produto, somando a quantidade
  {
    $group: {
      _id: {
        state: "$customer_state",
        sku: "$products.product_sku",
        name: "$products.name"
      },
      total_quantity_sold: {
        $sum: "$products.quantity"
      }
    }
  },
  
  // 3. Aplica a função de janela para rankear os produtos DENTRO de cada estado
  {
    $setWindowFields: {
      partitionBy: "$_id.state",
      sortBy: { total_quantity_sold: -1 },
      output: {
        rank: {
          $denseRank: {}
        }
      }
    }
  },
  
  // 4. Filtra para manter apenas os 20 primeiros produtos de cada estado (rank <= 20)
  {
    $match: {
      rank: { $lte: 20 }
    }
  },
  
  // 5. Projeta os campos finais para visualização limpa
  {
    $project: {
      _id: 0,
      state: "$_id.state",
      product_sku: "$_id.sku",
      product_name: "$_id.name",
      total_quantity_sold: 1,
      rank: 1
    }
  }
])