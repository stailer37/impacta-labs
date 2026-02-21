# Caso de Estudo - Amazonas (E-commerce)

## Grupo
Diário de Bordo

## Integrante(s)
- Gabriel Nakias Bonfim Pinheiro Ferreira
- RA: 1904845

## Objetivo
Modelar dados de cliques e compras em MongoDB para responder perguntas de negócio.

## Decisões de modelagem
Optamos por múltiplas collections:
- users: dados do cliente e estado
- products: catálogo com campos comuns + attributes flexível por tipo
- orders: compras com itens (qty, unitPrice, category) e total
- events: eventos de clique e compra (exemplos em JSON)

Motivos:
- Clique tende a ter alto volume, separar evita inflar usuário/produto
- Orders facilita métricas por período (últimos 30 dias) e por estado
- products com `attributes` facilita expansão para novos tipos sem alterar schema

## Query entregue
Pergunta respondida:
- "Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?"
Ver `command_mongo.sh`.