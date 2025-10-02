Nome: Daniel Silva Ramos

# Caso de Estudo NoSQL Documento

## Contexto

A empresa Amazonas do ramo de e-commerce deseja acompanhar os fluxos de cliques de seus clientes,
bem como rastrear os produtos que eles compram.Neste momento, a empresa vende livros, CDs e pequenos
eletrodomésticos de cozinha apenas, mas provavelmente irá expandir para outros produtos no futuro.

## Atividade

Amazonas quer ser capaz de responder às seguintes perguntas:

- Qual é a média de produtos comprados por cliente?
- Quais são os 20 produtos mais populares por estado dos clientes?
- Qual é o valor médio das vendas por estado do cliente?
- Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?

1. Vocês foram contratados para decidir qual a melhor maneira de organizar esses dados,
seja em uma coleção única ou múltiplas, e devem definir quais campos específicos que cada produto deve ter e os porquês.
2. Devem produzir um ou mais eventos de sistêmicos no formato JSON para exemplificar as decisões.
3. Devem escolher uma das quatro perguntas de negócio e gerar um comando MongoDB para responder.

* Cada representante do grupo irá criar uma branch do repositório impacta-labs com a seguinte estrutura:
`feat/caso_estudo_{nome_do_grupo}`
* Enviar um pull request contendo os artefatos:
Arquivo README.MD com os integrantes do grupo (fiquem a vontade para explicar os porquês das decisões no documento)
`collection_{nome_a_escolha}.json` (caso optem por mais de uma collection, deverá haver mais de um arquivo JSON)
command_mongo.sh
