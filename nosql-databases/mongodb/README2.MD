# Caso de Estudo - Amazonas E-commerce

## Integrantes
- Lucas Soares

---

## Modelagem Escolhida

Optamos por utilizar múltiplas collections:

- clientes
- produtos
- pedidos

### Justificativas

- Separação de responsabilidades
- Escalabilidade para novos tipos de produtos
- Evita duplicidade desnecessária
- Snapshot dos produtos dentro do pedido evita inconsistência caso o preço mude
- Campo estado_cliente foi duplicado no pedido para evitar operações de lookup e melhorar performance em consultas analíticas

---

## Pergunta de Negócio Escolhida

Qual é o valor médio das vendas por estado do cliente?

---

## Como Executar


db.pedidos.aggregate([
  {
    $group: {
      _id: "$estado_cliente",           // Agrupa por estado
      media_vendas: { $avg: "$valor_total" },  // Calcula média do valor_total
      total_vendas: { $sum: 1 }        // Opcional: número de pedidos por estado
    }
  },
  {
    $sort: { media_vendas: -1 }        // Ordena do maior para o menor
  }
])
```bash
bash command_mongo.sh
./command_mongo.sh