#!/bin/bash
# Indica que este é um script Bash

use amazonas
# Seleciona o banco de dados 'amazonas'

db.orders.aggregate([
  { $unwind: "$items" }, # Desagrega cada item do pedido
  { $lookup: { from: "customers", localField: "customerId", foreignField: "_id", as: "customer" } }, # Join com clientes
  { $unwind: "$customer" }, # Transformar array em objeto único
  { $group: {
      _id: { state: "$customer.address.state", productId: "$items.productId" },
      totalSold: { $sum: "$items.quantity" }, # Soma das quantidades vendidas
      totalRevenue: { $sum: { $multiply: ["$items.quantity", "$items.unitPrice"] } } # Receita total
  } },
  { $lookup: { from: "products", localField: "_id.productId", foreignField: "_id", as: "product" } }, # Join com produtos
  { $unwind: { path: "$product", preserveNullAndEmptyArrays: true } }, # Desagrega produtos, mantém null
  { $project: { state: "$_id.state", productId: "$_id.productId", productName: "$product.name", category: "$product.category", totalSold: 1, totalRevenue: 1 } }, # Seleção de campos
  { $sort: { state: 1, totalSold: -1 } }, # Ordena por estado e quantidade vendida
  { $group: { _id: "$state", products: { $push: { productId: "$productId", productName: "$productName", category: "$category", totalSold: "$totalSold", totalRevenue: "$totalRevenue" } } } }, # Agrupa produtos por estado
  { $project: { top20: { $slice: ["$products", 20] } } } # Mantém apenas os top 20 produtos por estado
])
