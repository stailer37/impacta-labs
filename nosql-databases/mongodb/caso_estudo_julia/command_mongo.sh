#!/bin/bash

mongo amazonas --eval '
db.pedidos.aggregate([
  {
    $match: {
      dataPedido: {
        $gte: new Date(new Date().setDate(new Date().getDate() - 30))
      }
    }
  },
  { $unwind: "$itens" },
  {
    $group: {
      _id: "$itens.categoria",
      totalVendido: { $sum: "$itens.quantidade" }
    }
  }
])
'