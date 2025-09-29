# Vinicius Ribeiro de Lima - RA: 1801174


## Motivo da escolha
A escolha por mais de uma coleção (uma para produtos, outra para pedidos e outra para cliques) foi pelos seguintes motivos:

1. Isolamento e Otimização: Ao separar os dados em coleções distintas, otimizamos as operações. Por exemplo, os cliques dos clientes são dados de alto volume e crescimento constante. Mantê-los separados permite que a coleta, inserção e análise desses dados aconteça de forma isolada, sem impactar as coleções de produtos e pedidos, que possuem um ritmo de atualização e acesso diferente.

2. Flexibilidade do Esquema: Como dito no comentário do exercicio, empresa Amazonas planeja expandir para novos tipos de produtos no futuro. Usar uma coleção única para todos os produtos faria com que o esquema se tornasse desordenado e difícil de gerenciar, com muitos campos nulos para produtos que não os utilizam. Com uma coleção de produtos unificada, mas com um esquema flexível, podemos adicionar facilmente novos campos específicos para diferentes tipos de produtos (por exemplo, peso para eletrodomésticos, autor para livros) sem a necessidade de migrações complexas ou coleções separadas por tipo de produto.

3. Desempenho de Leitura (Queries): A modelagem de dados do MongoDB é otimizada para o padrão de acesso da aplicação. As perguntas da Amazonas focam em análises de vendas, popularidade de produtos e comportamento de compra.

## Pergunta escolhida
Qual é o valor médio das vendas por estado do cliente??: Uma coleção de pedidos é ideal. Ela armazena um "snapshot" dos itens no momento da compra, incluindo preço e quantidade, o que evita a necessidade de consultas em várias coleções para calcular totais.

### Query:
```
db.pedidos.aggregate([
  {
    $group: {
      _id: "$estado_cliente",
      valor_medio_vendas: { $avg: "$valor_total" }
    }
  },
  {
    $sort: { "_id": 1 } 
  }
])
```
## Estrutura das Coleções
### 1. PRODUTOS
Esta coleção armazenará os dados dos produtos, com um campo tipo_produto para identificação e campos adicionais flexíveis.
```
	id_produto: String (ID único do produto)
	nome: String (nome do produto)
	valor_unitario: Double (preço atual de venda)
	tipo_produto: String (ex: "livro", "cd", "eletrodomestico")
	quantidade_estoque: Int (quantidade disponível)
	descricao: Object (documento aninhado com detalhes específicos do tipo de produto, como autor para livros ou voltagem para eletrodomésticos)
```
### 2. PEDIDOS
Esta coleção é o coração das análises de vendas. Cada documento representa um pedido de compra finalizado.
```
	id_pedido: String (ID único do pedido)
	id_cliente: String (ID único do cliente que fez o pedido)
	estado_cliente: String (estado do cliente para análises geográficas)
	data_compra: Date (timestamp da compra)
	valor_total: Double (valor total do pedido)
	produtos: Array (uma lista de produtos comprados no pedido)
	Cada item no array é um documento aninhado que contém:
	id_produto: String (referência ao ID único do produto na coleção produtos)
	nome_produto: String (nome do produto no momento da compra)
	valor_pago: Double (valor do produto no momento da compra)
	quantidade_comprada: Int (quantidade de itens comprados)
```
### 3. CLIQUES
Esta coleção registra as interações dos clientes no site.
```
	id_evento: String (ID único do evento de clique)
	id_cliente: String (ID do cliente)
	timestamp: Date (data e hora do evento)
	tipo_evento: String (ex: "visualizacao_produto", "adicionar_carrinho", "busca")
	detalhes_evento: Object (documento aninhado com informações extras, como id_produto para visualizações ou termo_buscado para buscas)
```
