# Caso de Estudo – Empresa Amazonas (E-commerce)

## 📌 Decisão de Modelagem

Optamos por utilizar múltiplas collections no MongoDB:

- clientes
- produtos
- pedidos
- eventos_cliques

### ✅ Justificativa

1. Escalabilidade futura (novas categorias de produtos)
2. Separação entre dados transacionais e comportamentais
3. Melhor performance para consultas analíticas
4. Evita duplicação desnecessária de dados
5. Permite histórico correto de preços (snapshot no pedido)

---

## 📦 Collections

### clientes
Armazena dados cadastrais do cliente.

### produtos
Armazena todos os produtos vendidos.
Campo "categoria" permite expansão futura.

### pedidos
Armazena compras realizadas.
Os itens são embutidos no pedido para facilitar cálculos analíticos.

### eventos_cliques
Armazena interações dos usuários (view, add_to_cart, purchase).

---

## 📊 Pergunta de Negócio Escolhida

"Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?"

Essa pergunta foi escolhida pois:
- Permite análise recente de desempenho
- Ajuda no planejamento de estoque
- Auxilia decisões comerciais