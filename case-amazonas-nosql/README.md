# Case NoSQL — Amazonas (MongoDB)

> **Integrantes do grupo**
> - Talita Vieira Nobrega
> - Lucas S. L. Candido


## Objetivo
Organizar dados de e-commerce (livros, CDs e pequenos eletrodomésticos de cozinha) para responder às perguntas:
1. Média de produtos comprados por cliente
2. Top **20** produtos mais populares por **estado** do cliente
3. Valor médio das vendas por **estado** do cliente
4. Quantidade vendida por **categoria** nos **últimos 30 dias**

## Decisões de modelagem (MongoDB)
Adotamos **múltiplas coleções** para separar catálogo, clientes, pedidos e eventos de clique:
- `products`: metadados do produto e atributos específicos por tipo
- `customers`: cadastro e endereço (snapshot do estado padrão)
- `orders`: **denormalizado** com `customer_state` e metadados do item, para análises rápidas sem `$lookup`
- `click_events`: page/product views, add-to-cart etc.

### Campos essenciais (resumo)
- **products**: `sku`, `title`, `category`, `price.amount`, `attributes{...}` polimórfico (ex.: `author` para books, `artist` para cds, `power_watts` para appliances).
- **customers**: `customer_id`, `default_state`, `addresses[].state`.
- **orders**: `order_id`, `customer_id`, `customer_state`, `order_date`, `payment.total`, `items[].{product_id, sku, title, category, unit_price, qty}`, `status`.
- **click_events**: `event_ts`, `session_id`, `customer_id|null`, `event_type`, `product{product_id, sku, category}`, `geo.state` (quando disponível).

**Por quê denormalizar `orders`?**
- Evitar joins caros para as consultas de negócio.
- Garantir reprocesso independente de mudanças no cadastro/produtos (snapshot dos dados relevantes).

## Como executar (local)
Pré-requisitos: Docker (ou MongoDB local), `mongosh` e `mongoimport` disponíveis no PATH.

```bash
# Subir Mongo com Docker (opcional)
docker compose up -d

# Importar coleções e rodar a consulta escolhida (Q2) — ver comando abaixo
bash command_mongo.sh
```

### Consulta exigida (entregável): **Top 20 produtos por estado**
- Arquivo: `command_mongo.sh` (usa `mongosh` com pipeline inline).
- Coleção: `orders`
- Estratégia: `unwind items` → `group por (customer_state, product)` → ordenar e cortar Top 20 por estado

### Índices recomendados
Executados automaticamente pelo script:
- `orders`: `{ status:1, order_date:-1 }`, `{ customer_state:1 }`, `{ "items.product_id":1 }`
- `products`: `{ category:1, status:1 }`
- `customers`: `{ default_state:1 }`

## Observações
- Os arquivos `collection_*.json` são **JSON Array** para uso com `mongoimport --jsonArray`.
- Dados são exemplos mínimos apenas para demonstrar o funcionamento dos pipelines.

