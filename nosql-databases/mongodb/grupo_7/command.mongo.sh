#!/bin/bash
DB_NAME="amazonas_ecommerce"

mongosh "$DB_NAME" --eval '
  printjson(
    db.compras.aggregate([
      { $unwind: "$produtos" },
      {
        $group: {
          _id: "$cliente_id",
          total_produtos_por_cliente: { $sum: "$produtos.quantidade" }
        }
      },
      {
        $group: {
          _id: null,
          total_produtos_comprados: { $sum: "$total_produtos_por_cliente" },
          total_clientes_unicos: { $sum: 1 }
        }
      },
      {
        $project: {
          _id: 0,
          Media_produtos_por_cliente: {
            $divide: ["$total_produtos_comprados", "$total_clientes_unicos"]
          }
        }
      }
    ]).toArray()
  )
'