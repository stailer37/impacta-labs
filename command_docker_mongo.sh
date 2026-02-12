#!/bin/bash

echo "========================================="
echo "   Setup Banco MongoDB - Amazonas"
echo "========================================="

# 1. Garante que não haja um container antigo com o mesmo nome
docker rm -f mongo 2>/dev/null

# 2. Inicia o novo container
echo "Iniciando container..."
docker run --name mongo -p 27017:27017 -d mongo:latest

# 3. Aguarda o MongoDB inicializar (cerca de 5 a 10 segundos)
echo "Aguardando o MongoDB ficar pronto..."
sleep 7

# 4. Executa o setup das coleções
docker exec -i mongo mongosh <<'EOF'

use amazonas

print("Criando collections...")

// ================================
// Collection: customers
// ================================
db.createCollection("customers", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["customer_id", "name", "email", "state", "created_at"],
         properties: {
            customer_id: { bsonType: "string" },
            name: { bsonType: "string" },
            email: { bsonType: "string" },
            state: { bsonType: "string" },
            created_at: { bsonType: ["date", "string"] }
         }
      }
   }
})

db.customers.createIndex({ customer_id: 1 }, { unique: true })
db.customers.createIndex({ state: 1 })

// ================================
// Collection: products
// ================================
db.createCollection("products", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["product_id", "name", "category", "price", "created_at"],
         properties: {
            product_id: { bsonType: "string" },
            name: { bsonType: "string" },
            category: { bsonType: "string" },
            price: { bsonType: "double" },
            created_at: { bsonType: ["date", "string"] }
         }
      }
   }
})

db.products.createIndex({ product_id: 1 }, { unique: true })
db.products.createIndex({ category: 1 })

// ================================
// Collection: orders
// ================================
db.createCollection("orders", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["order_id", "customer_id", "customer_state", "items", "total_amount", "created_at"],
         properties: {
            order_id: { bsonType: "string" },
            customer_id: { bsonType: "string" },
            customer_state: { bsonType: "string" },
            items: {
               bsonType: "array",
               items: {
                  bsonType: "object",
                  required: ["product_id", "name", "category", "quantity", "unit_price"],
                  properties: {
                     product_id: { bsonType: "string" },
                     name: { bsonType: "string" },
                     category: { bsonType: "string" },
                     quantity: { bsonType: "int" },
                     unit_price: { bsonType: "double" }
                  }
               }
            },
            total_amount: { bsonType: "double" },
            created_at: { bsonType: ["date", "string"] }
         }
      }
   }
})

db.orders.createIndex({ order_id: 1 }, { unique: true })
db.orders.createIndex({ customer_id: 1 })
db.orders.createIndex({ customer_state: 1 })
db.orders.createIndex({ created_at: -1 })
db.orders.createIndex({ "items.product_id": 1 })

// ================================
// Collection: click_events
// ================================
db.createCollection("click_events", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["event_id", "customer_id", "product_id", "session_id", "event_type", "timestamp"],
         properties: {
            event_id: { bsonType: "string" },
            customer_id: { bsonType: "string" },
            product_id: { bsonType: "string" },
            session_id: { bsonType: "string" },
            event_type: { bsonType: "string" },
            timestamp: { bsonType: ["date", "string"] }
         }
      }
   }
})

db.click_events.createIndex({ event_id: 1 }, { unique: true })
db.click_events.createIndex({ customer_id: 1 })
db.click_events.createIndex({ product_id: 1 })
db.click_events.createIndex({ timestamp: -1 })

print("Collections e índices criados com sucesso!")

EOF

echo ""
echo "========================================="
echo " Para importar os dados execute:"
echo "========================================="
echo "docker exec -i mongo mongoimport --db amazonas --collection customers --jsonArray < collection_customers.json"
echo "docker exec -i mongo mongoimport --db amazonas --collection products --jsonArray < collection_products.json"
echo "docker exec -i mongo mongoimport --db amazonas --collection orders --jsonArray < collection_orders.json"
echo "docker exec -i mongo mongoimport --db amazonas --collection click_events --jsonArray < collection_click_events.json"
echo ""
echo "=================================================="
echo " Para verificar as coleções e outros execute:"
echo "=================================================="
echo "docker exec -it mongo mongosh amazonas"
echo "show collections"
echo "db.customers.getIndexes()"
echo "db.customers.countDocuments()"
echo ""
echo "Setup finalizado."



