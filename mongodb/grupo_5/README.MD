Projeto de Análise de Compras

Integrantes

Guilherme Dias - RA: 2402809

Gabriel Anchieta de Sales - RA: 2402904

Glauco Chagas Bertolaccini - RA: 2403458

Isabella Simoes - RA: 2403930

Luis Correia - RA: 2404289

Criação da Collection

A nossa collection será chamada db.compras, contendo os seguintes campos:

{
    "id_cliente": "Código único do cliente",
    "nome_cliente": "Nome do usuário que realizou a compra",
    "data_compra": "Data da transação (registro gravado como data)",
    "produto": "Produto comprado",
    "quantidade": "Quantidade comprada do item",
    "categoria_produto": "ID da categoria do produto",
    "valor_produto": "Valor unitário do item"
}

Estes são os campos que entendemos como essenciais para registrar uma transação de compra em uma loja.

Pergunta de Análise

Decidimos analisar a seguinte questão: Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?

Operadores Utilizados

aggregate: Usado para agrupar os itens por categoria.

$match: Utilizado para filtrar documentos com base em determinados critérios.

$gte: Condição "maior ou igual".

$group: Utilizado para agrupar documentos por algum campo específico e realizar operações agregadas.

$project: Utilizado para especificar quais campos devem ser incluídos ou excluídos no resultado da agregação, permitindo reformular os documentos.