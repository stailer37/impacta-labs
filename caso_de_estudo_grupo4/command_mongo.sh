#!/bin/bash
mongo <<EOF
use amazonas

db.sales.aggregate([
  {
    \$lookup: {
      from: "customers",
      localField: "customer_id",
      foreignField: "_id",
      as: "customer"
    }
  },
  { \$unwind: "\$customer" },
  {
    \$group: {
      _id: "\$customer.state",
      average_sales: { \$avg: "\$total_amount" }
    }
  },
  { \$sort: { average_sales: -1 } }
])
EOF
