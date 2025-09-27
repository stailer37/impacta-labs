#!/usr/bin/env bash
# Executa todas as 4 consultas do case NoSQL Amazonas
DB_NAME=${1:-amazonas}

echo "1) Média de produtos comprados por cliente:"
mongosh "$DB_NAME" --quiet --eval '
db.orders.aggregate([
  { $match: { status: "completed" } },
  { $unwind: "$items" },
  { $group: { _id: "$customer_id", total_products: { $sum: "$items.quantity" } } },
  { $group: { _id: null, avg_products_per_customer: { $avg: "$total_products" } } }
]).forEach(doc => printjson(doc));
'

echo "\n2) Top 20 produtos mais populares por estado:"
mongosh "$DB_NAME" --quiet --eval '
db.orders.aggregate([
  { $match: { status: "completed" } },
  { $unwind: "$items" },
  { $group: { _id: { state: "$customer_state", product_id: "$items.product_id", product_name: "$items.product_name" }, qty: { $sum: "$items.quantity" } } },
  { $setWindowFields: { partitionBy: "$_id.state", sortBy: { qty: -1 }, output: { rank: { $rank: {} } } } },
  { $match: { rank: { $lte: 20 } } },
  { $project: { _id: 0, state: "$_id.state", product_id: "$_id.product_id", product_name: "$_id.product_name", qty: 1, rank: 1 } },
  { $sort: { state: 1, rank: 1 } }
]).forEach(doc => printjson(doc));
'

echo "\n3) Valor médio das vendas por estado:"
mongosh "$DB_NAME" --quiet --eval '
db.orders.aggregate([
  { $match: { status: "completed" } },
  { $group: { _id: "$customer_state", avg_order_value: { $avg: "$order_total" } } },
  { $project: { _id: 0, state: "$_id", avg_order_value: 1 } },
  { $sort: { state: 1 } }
]).forEach(doc => printjson(doc));
'

echo "\n4) Quantidade de produtos vendidos nos últimos 30 dias:"
mongosh "$DB_NAME" --quiet --eval '
db.orders.aggregate([
  { $match: { status: "completed", created_at: { $gte: ISODate(new Date(Date.now() - 1000*60*60*24*30).toISOString()) } } },
  { $unwind: "$items" },
  { $group: { _id: "$items.category", total_sold: { $sum: "$items.quantity" } } },
  { $project: { _id: 0, category: "$_id", total_sold: 1 } },
  { $sort: { total_sold: -1 } }
]).forEach(doc => printjson(doc));
'
