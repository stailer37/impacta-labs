#!/bin/bash
# Pergunta: Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?

mongosh "mongodb://localhost:27017/amazonas" --quiet --eval '
db.orders.aggregate([
  { $match: { createdAt: { $gte: new Date(Date.now() - 30*24*60*60*1000) } } },
  { $unwind: "$items" },
  { $group: { _id: "$items.category", totalQty: { $sum: "$items.qty" } } },
  { $sort: { totalQty: -1 } }
]).toArray()
'