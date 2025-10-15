#!/bin/bash
# Script para consultar a quantidade de produtos vendidos por categoria.
# VERSÃO COM SAÍDA JSON FORMATADA.

# --- CONFIGURAÇÃO ---
CONTAINER_NAME="mongodb-standalone"
DB_NAME="amazonasDB"
# --- FIM DA CONFIGURAÇÃO ---

echo "Executando agregação no banco de dados '$DB_NAME' dentro do container '$CONTAINER_NAME'..."

# A mudança está aqui: removemos o '.forEach(printjson)' no final.
# O mongosh agora vai imprimir o resultado como um array JSON único e limpo.
docker exec $CONTAINER_NAME mongosh $DB_NAME --eval '
db.pedidos.aggregate([
  {
    $match: {
      "data_pedido": {
        $gte: ISODate("2025-09-15T00:00:00Z")
      }
    }
  },
  {
    $unwind: "$itens"
  },
  {
    $group: {
      _id: "$itens.categoria_produto",
      total_vendido: { $sum: "$itens.quantidade" }
    }
  },
  {
    $project: {
      _id: 0,
      categoria: "$_id",
      total_vendido: 1
    }
  },
  {
    $sort: { // Adicionando um estágio de ordenação para ficar mais organizado
      categoria: 1
    }
  }
])
'