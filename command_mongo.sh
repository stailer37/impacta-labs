mongosh <<EOF
use amazonas;

// Pergunta respondida
var mediaVendas = db.orders.aggregate([
  { \$unwind: "\$items" },
  { \$group: { _id: "\$state", media_valor_vendas: { \$avg: { \$multiply: ["\$items.unit_price", "\$items.quantity"] } } } }
]).toArray();
printjson(mediaVendas);
EOF