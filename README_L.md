# Caso de Estudo NoSQL - Amazonas

## Integrante
- Lilian Santos Souza  RA: 2502186  

## Decisões de modelagem

A empresa Amazonas deseja acompanhar cliques e compras dos clientes. 

Optei por usar **múltiplas coleções** para facilitar a escalabilidade e a clareza das consultas:

- `clientes`: dados cadastrais e localização
- `produtos`: informações dos itens vendidos
- `compras`: histórico de vendas por cliente
- `cliques`: rastreamento de interesse por produto

Essa estrutura permite responder facilmente às perguntas de negócio e adaptar o sistema para novos tipos de produtos no futuro.

## Pergunta escolhida

**Qual é o valor médio das vendas por estado ?**

Utilizei o comando MongoDB com `aggregate` e `lookup` para unir dados de clientes e compras e calcular a média por estado.

