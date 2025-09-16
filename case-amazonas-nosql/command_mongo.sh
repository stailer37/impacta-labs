#!/usr/bin/env bash
set -euo pipefail

# Configuráveis
DB_NAME=${DB_NAME:-amazonas}
MONGO_URI=${MONGO_URI:-"mongodb://localhost:27017"}

echo "==> Importando coleções para '$DB_NAME' em $MONGO_URI"

# --jsonArray porque os arquivos são arrays JSON
mongoimport --uri "$MONGO_URI/$DB_NAME" -c products      --drop --jsonArray --file collection_products.json
mongoimport --uri "$MONGO_URI/$DB_NAME" -c customers     --drop --jsonArray --file collection_customers.json
mongoimport --uri "$MONGO_URI/$DB_NAME" -c orders        --drop --jsonArray --file collection_orders.json
mongoimport --uri "$MONGO_URI/$DB_NAME" -c click_events  --drop --jsonArray --file collection_click_events.json

echo "==> Criando índices recomendados"
mongosh "$MONGO_URI/$DB_NAME" <<'MJS'
db.orders.createIndex({ status: 1, order_date: -1 });
db.orders.createIndex({ customer_state: 1 });
db.orders.createIndex({ "items.product_id": 1 });
db.products.createIndex({ category: 1, status: 1 });
db.customers.createIndex({ default_state: 1 });
MJS

echo "==> Executando consulta escolhida (Q2): Top 20 produtos por estado"
mongosh "$MONGO_URI/$DB_NAME" <<'MJS'
db.orders.aggregate([
  { $match: { status: "paid" } },
  { $unwind: "$items" },
  { $group: {
      _id: { state: "$customer_state", product: "$items.product_id" },
      total_qty: { $sum: "$items.qty" },
      sku: { $first: "$items.sku" },
      title: { $first: "$items.title" },
      category: { $first: "$items.category" }
  }},
  { $sort: { "_id.state": 1, total_qty: -1 } },
  { $group: {
      _id: "$_id.state",
      products: {
        $push: {
          product_id: "$_id.product",
          sku: "$sku",
          title: "$title",
          category: "$category",
          total_qty: "$total_qty"
        }
      }
  }},
  { $project: { _id: 0, state: "$_id", top20_products: { $slice: ["$products", 20] } } }
]).forEach(doc => printjson(doc));
MJS

echo "==> (Opcional) Outras consultas úteis"
echo "    - Q1 média de produtos por cliente"
mongosh "$MONGO_URI/$DB_NAME" <<'MJS'
db.orders.aggregate([
  { $match: { status: "paid" } },
  { $unwind: "$items" },
  { $group: { _id: "$customer_id", units: { $sum: "$items.qty" } } },
  { $group: { _id: null, avg_units_per_customer: { $avg: "$units" } } },
  { $project: { _id: 0, avg_units_per_customer: 1 } }
]).forEach(doc => printjson(doc));
MJS

echo "    - Q3 ticket médio por estado"
mongosh "$MONGO_URI/$DB_NAME" <<'MJS'
db.orders.aggregate([
  { $match: { status: "paid" } },
  { $group: {
      _id: "$customer_state",
      avg_order_value: { $avg: "$payment.total" },
      orders: { $sum: 1 }
  }},
  { $project: { _id: 0, state: "$_id", avg_order_value: 1, orders: 1 } },
  { $sort: { state: 1 } }
]).forEach(doc => printjson(doc));
MJS

echo "    - Q4 quantidade por categoria (últimos 30 dias)"
mongosh "$MONGO_URI/$DB_NAME" <<'MJS'
db.orders.aggregate([
  { $match: {
      status: "paid",
      order_date: { $gte: new Date(Date.now() - 1000*60*60*24*30) }
  }},
  { $unwind: "$items" },
  { $group: { _id: "$items.category", total_qty: { $sum: "$items.qty" } } },
  { $project: { _id: 0, category: "$_id", total_qty: 1 } },
  { $sort: { total_qty: -1 } }
]).forEach(doc => printjson(doc));
MJS

echo "==> Fim"
