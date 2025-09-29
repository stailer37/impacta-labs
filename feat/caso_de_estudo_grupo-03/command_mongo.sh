#!/bin/bash

# Importação dos dados
mongoimport --db amazonas --collection clientes --file clientes.json --jsonArray
mongoimport --db amazonas --collection produtos --file produtos.json --jsonArray
mongoimport --db amazonas --collection vendas --file vendas.json --jsonArray

# Análise dos dados
echo "=== ANÁLISE RÁPIDA - AMAZONAS ==="

# 1. Média de produtos por cliente
echo "1. MÉDIA DE PRODUTOS POR CLIENTE:"
mongosh amazonas --quiet --eval "
db.vendas.aggregate([
  {\$group: {_id: '\$cliente_id', total: {\$sum: {\$size: '\$itens'}}}},
  {\$group: {_id: null, media: {\$avg: '\$total'}}},
  {\$project: {_id: 0, 'Média': {\$round: ['\$media', 2]}}}
])"
echo ""

# 2. Top 5 produtos por estado (resumido)
echo "2. TOP 5 PRODUTOS POR ESTADO:"
mongosh amazonas --quiet --eval "
db.vendas.aggregate([
  {\$unwind: '\$itens'},
  {\$group: {_id: {estado: '\$estado_cliente', produto: '\$itens.nome'}, total: {\$sum: '\$itens.quantidade'}}},
  {\$sort: {'_id.estado': 1, 'total': -1}},
  {\$group: {_id: '\$_id.estado', top: {\$push: {produto: '\$_id.produto', qtd: '\$total'}}}},
  {\$project: {estado: '\$_id', top5: {\$slice: ['\$top', 5]}}},
  {\$sort: {estado: 1}}
])"
echo ""

# 3. Valor médio por estado
echo "3. VALOR MÉDIO POR ESTADO:"
mongosh amazonas --quiet --eval "
db.vendas.aggregate([
  {\$group: {_id: '\$estado_cliente', media: {\$avg: '\$valor_total'}}},
  {\$project: {_id: 0, Estado: '\$_id', 'Valor Médio (R$)': {\$round: ['\$media', 2]}}},
  {\$sort: {'Valor Médio (R$)': -1}}
])"
echo ""

# 4. Vendas por categoria (30 dias)
echo "4. VENDAS POR CATEGORIA (30 DIAS):"
mongosh amazonas --quiet --eval "
var trintaDias = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
db.vendas.aggregate([
  {\$match: {'data_venda': {\$gte: trintaDias}}},
  {\$unwind: '\$itens'},
  {\$group: {_id: '\$itens.categoria', total: {\$sum: '\$itens.quantidade'}}},
  {\$project: {_id: 0, Categoria: '\$_id', 'Quantidade': 1}},
  {\$sort: {Quantidade: -1}}
])"
echo ""

echo "=== FIM DA ANÁLISE ==="