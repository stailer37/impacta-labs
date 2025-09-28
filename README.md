# README.MD

## Integrantes

- Felipe Ensinas Alves - 2500260
- Felipe Santos Araújo - 2502219

## Objetivo

O trabalho consiste em projetar o armazenamento dos dados de ações de clientes (cliques, visualizações e compras) e vendas de produtos da empresa Amazonas (e-commerce), permitindo responder às perguntas de negócio:  

1. Qual é a média de produtos comprados por cliente?  
2. Quais são os 20 produtos mais populares por estado?  
3. Qual é o valor médio das vendas por estado?  
4. Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?  

---

## Decisão arquitetural

Optamos por **múltiplas collections** com responsabilidades claras:

1. **products** → informações de cada produto (categoria, preço, atributos, disponibilidade).  
2. **customers** → dados do cliente (nome, e-mail, endereço, telefone).  
3. **orders** → histórico de pedidos, itens comprados, endereço de entrega e totais.  
4. **events** → rastreio de comportamento do cliente (cliques, visualizações, adições ao carrinho).  

### Por que múltiplas collections?

- Separação de responsabilidades  
- Escalabilidade: cada collection pode crescer independentemente  
- Consultas mais eficientes e flexíveis  
- Facilita a inclusão de novas categorias ou tipos de eventos no futuro  

---

## Estrutura das collections

- **collection_products.json** → 20 produtos de categorias `livro`, `cd` e `eletrodoméstico`.  
- **collection_customers.json** → 5 clientes distribuídos por estados SP, RJ e MG.  
- **collection_orders.json** → pedidos de clientes distribuídos entre os 20 produtos, com quantidades variadas.  
- **collection_events.json** → eventos de visualização e adição ao carrinho para simular comportamento do cliente.  

---

## Pergunta de negócio escolhida

**Quais são os 20 produtos mais populares por estado dos clientes?**  

Para isso, usamos um **aggregate MongoDB** que:

1. Desagrega os itens de cada pedido (`$unwind: "$items"`)  
2. Faz join com os clientes (`$lookup`) para obter o estado  
3. Agrupa por estado e produto, somando quantidade vendida e receita (`$group`)  
4. Faz join com produtos para incluir nome e categoria  
5. Ordena por quantidade vendida e seleciona os **top 20 produtos por estado** (`$slice`)  

---

## Arquivos no repositório

- `collection_products.json`  
- `collection_customers.json`  
- `collection_orders.json`  
- `collection_events.json`  
- `command_mongo.sh`  

---

## Observações finais

- Índices recomendados para performance: `orders.customerId`, `orders.items.productId`  
- O modelo é extensível para novas categorias e eventos futuros  
- As collections permitem gerar **relatórios de vendas, análise de comportamento e métricas de performance**  
- Com os dados de exemplo fornecidos, ao rodar o aggregate no MongoDB, será possível visualizar os **top 20 produtos por estado**, simulando um cenário real de análise de vendas