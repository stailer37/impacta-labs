#!/bin/bash

docker exec -i mongodb mongosh <<EOF
use amazonas

db.compras.aggregate([
  {
    \$lookup: {
      from: "clientes",
      localField: "cliente_id",
      foreignField: "_id",
      as: "cliente"
    }
  },
  { \$unwind: "\$cliente" },
  {
    \$group: {
      _id: "\$cliente.estado",
      media_vendas: { \$avg: "\$valor_total" }
    }
  },
  {
    \$project: {
      _id: 0,
      UF: "\$_id",
      media_vendas: 1
    }
  }
])
EOF



