#!/bin/bash

mongo amazonas --eval '

db.orders.aggregate([

  {
    $unwind: "$items"
  },

  {
    $group: {
      _id: {
        state: "$customer_state",
        product: "$items.product_name"
      },
      total_vendido: { $sum: "$items.quantity" }
    }
  },

  {
    $sort: {
      "_id.state": 1,
      total_vendido: -1
    }
  },

  {
    $group: {
      _id: "$_id.state",
      produtos: {
        $push: {
          nome: "$_id.product",
          quantidade: "$total_vendido"
        }
      }
    }
  },

  {
    $project: {
      _id: 0,
      estado: "$_id",
      top_20: { $slice: ["$produtos", 20] }
    }
  }

])

'