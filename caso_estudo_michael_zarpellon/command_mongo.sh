#!/bin/bash

# ====================================
# Caso de Estudo - Amazonas E-Commerce
# ====================================

DB_NAME="amazonas_ecommerce"
MONGO_URI="mongodb://localhost:27017/$DB_NAME"

echo "================================"
echo "Importando coleções..."
echo "================================"

mongoimport --uri="$MONGO_URI" --db $DB_NAME --collection customers --file customers.json --jsonArray
mongoimport --uri="$MONGO_URI" --db $DB_NAME --collection products --file products.json --jsonArray
mongoimport --uri="$MONGO_URI" --db $DB_NAME --collection orders --file orders.json --jsonArray
mongoimport --uri="$MONGO_URI" --db $DB_NAME --collection click_events --file click_events.json --jsonArray

echo "================================"
echo "Criando indíces!"
echo "================================"

mongosh "$MONGO_URI" --eval 'db.customers.createIndex({customer_id: 1})'
mongosh "$MONGO_URI" --eval 'db.orders.createIndex({customer_id: 1})'
mongosh "$MONGO_URI" --eval 'db.click_events.createIndex({customer_id: 1})'
mongosh "$MONGO_URI" --eval 'db.products.createIndex({product_id: 1})'

echo "============================================"
echo "1) Média de produtos por cliente"
echo "============================================"

mongosh  "$MONGO_URI" --eval '
db.orders.aggregate([
  { $unwind: "$items" },
  {
    $group: {
      _id: "$customer_id",
      total_produtos: { $sum: "$items.quantity" }
    }
  },
  {
    $group: {
      _id: null,
      media_produtos_por_cliente: { $avg: "$total_produtos" }
    }
  }
]).pretty();
'

echo "============================================"
echo "2) Top 20 produtos mais populares por estado"
echo "============================================"

mongosh "$MONGO_URI" --eval '
db.orders.aggregate([
  { $unwind: "$items" },
  {
    $group: {
      _id: {
        estado: "$customer_state",
        produto: "$items.product_id"
      },
      total_vendido: { $sum: "$items.quantity" }
    }
  },
  { $sort: { total_vendido: -1 } },
  { $limit: 20 }
]).pretty();
'

echo "============================================"
echo "3) Valor médio das vendas por estado"
echo "============================================"

mongosh "$MONGO_URI" --eval '
db.orders.aggregate([
  {
    $group: {
      _id: "$customer_state",
      valor_medio_vendas: { $avg: "$total_amount" }
    }
  },
  { $sort: { valor_medio_vendas: -1 } }
]).pretty();
'

echo "============================================"
echo "4) Produtos vendidos por categoria nos últimos 30 dias"
echo "============================================"

mongosh "$MONGO_URI" --eval '
db.orders.aggregate([
  {
    $match: {
      order_date: {
        $gte: new Date(new Date().setDate(new Date().getDate() - 30))
      }
    }
  },
  { $unwind: "$items" },
  {
    $group: {
      _id: "$items.category",
      total_vendido: { $sum: "$items.quantity" }
    }
  },
  { $sort: { total_vendido: -1 } }
]).pretty();
'

echo "============================================"
echo "Execução finalizada!"
echo "============================================"