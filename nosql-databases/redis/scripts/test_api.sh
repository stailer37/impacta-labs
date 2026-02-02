#!/bin/bash

# Script de teste da API REST do encurtador de URLs

API_URL="http://localhost:5000"

echo "=========================================="
echo "  Testes da API - Encurtador de URLs"
echo "=========================================="
echo ""

echo "1. Verificando se a API está rodando..."
curl -s "$API_URL/" | python3 -m json.tool
echo ""
echo ""

echo "2. Criando URLs encurtadas..."
echo ""

echo "   → Criando URL 1 (Google)..."
RESPONSE1=$(curl -s -X POST "$API_URL/api/shorten" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://www.google.com", "user_id": "user123"}')
echo "$RESPONSE1" | python3 -m json.tool
SHORT_CODE1=$(echo "$RESPONSE1" | python3 -c "import sys, json; print(json.load(sys.stdin)['short_code'])")
echo ""

echo "   → Criando URL 2 (GitHub)..."
RESPONSE2=$(curl -s -X POST "$API_URL/api/shorten" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://github.com/redis/redis", "user_id": "user123"}')
echo "$RESPONSE2" | python3 -m json.tool
SHORT_CODE2=$(echo "$RESPONSE2" | python3 -c "import sys, json; print(json.load(sys.stdin)['short_code'])")
echo ""

echo "   → Criando URL 3 (YouTube)..."
RESPONSE3=$(curl -s -X POST "$API_URL/api/shorten" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ", "user_id": "user456"}')
echo "$RESPONSE3" | python3 -m json.tool
SHORT_CODE3=$(echo "$RESPONSE3" | python3 -c "import sys, json; print(json.load(sys.stdin)['short_code'])")
echo ""
echo ""

echo "3. Simulando acessos (redirecionamentos)..."
echo ""

echo "   → Acessando URL $SHORT_CODE1 (5 vezes)..."
for i in {1..5}; do
  curl -s -o /dev/null "$API_URL/$SHORT_CODE1"
done
echo "   ✓ 5 acessos registrados"
echo ""

echo "   → Acessando URL $SHORT_CODE2 (10 vezes)..."
for i in {1..10}; do
  curl -s -o /dev/null "$API_URL/$SHORT_CODE2"
done
echo "   ✓ 10 acessos registrados"
echo ""

echo "   → Acessando URL $SHORT_CODE3 (3 vezes)..."
for i in {1..3}; do
  curl -s -o /dev/null "$API_URL/$SHORT_CODE3"
done
echo "   ✓ 3 acessos registrados"
echo ""
echo ""

echo "4. Consultando estatísticas de uma URL..."
curl -s "$API_URL/api/urls/$SHORT_CODE2/stats" | python3 -m json.tool
echo ""
echo ""

echo "5. Top URLs mais populares..."
curl -s "$API_URL/api/top?limit=3" | python3 -m json.tool
echo ""
echo ""

echo "6. URLs mais recentes..."
curl -s "$API_URL/api/recent?limit=3" | python3 -m json.tool
echo ""
echo ""

echo "7. URLs criadas pelo user123..."
curl -s "$API_URL/api/users/user123/urls" | python3 -m json.tool
echo ""
echo ""

echo "8. Desativando uma URL..."
curl -s -X PATCH "$API_URL/api/urls/$SHORT_CODE3" \
  -H "Content-Type: application/json" \
  -d '{"is_active": false}' | python3 -m json.tool
echo ""
echo ""

echo "9. Tentando acessar URL desativada..."
curl -s "$API_URL/$SHORT_CODE3" | python3 -m json.tool
echo ""
echo ""

echo "10. Estatísticas gerais do sistema..."
curl -s "$API_URL/api/stats" | python3 -m json.tool
echo ""
echo ""

echo "=========================================="
echo "  Testes concluídos!"
echo "=========================================="
