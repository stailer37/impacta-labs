#!/bin/bash
mongo --quiet --eval '
db.orders.aggregate([
  {
    $match: {
      timestamp: {
        $gte: new Date(new Date().setDate(new Date().getDate() - 30))
      }
    }
  },
  {
    $unwind: "$products"
  },
  {
    $group: {
      _id: "$products.category",
      totalSold: {
        $sum: "$products.quantity"
      }
    }
  },
  {
    $sort: {
      totalSold: -1
    }
  }
]).forEach(printjson)
'