#!/bin/bash

mongosh amazonas --eval '
db.pedidos.aggregate([
  {
    $group: {
      _id: "$estado_cliente",
      media_vendas: { $avg: "$valor_total" },
      total_vendas: { $sum: 1 }
    }
  },
  {
    $sort: { media_vendas: -1 }
  }
])
'