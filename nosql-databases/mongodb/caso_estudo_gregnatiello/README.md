# Caso de Estudo – MongoDB
## Empresa Amazonas – E-commerce

### Integrante
**Gregory Viana Natiello**

---

## Decisão de Modelagem

Optou-se pela utilização de múltiplas collections:

- `customers`
- `products`
- `orders`

A separação foi definida com base nos seguintes critérios:

- Clientes e produtos são entidades independentes
- Pedidos representam eventos transacionais
- Redução de redundância desnecessária
- Melhor escalabilidade para inclusão futura de novos tipos de produtos

Na collection `orders`, foi aplicada desnormalização estratégica, armazenando:

- Estado do cliente (`customer_state`)
- Nome do produto
- Categoria
- Preço unitário

Essa decisão melhora a performance das consultas analíticas e preserva o histórico das transações.

A escolha por múltiplas collections foi motivada pela separação de responsabilidades entre entidades principais (clientes e produtos) e eventos transacionais (pedidos).
---

## Estrutura das Collections

### `customers`
Armazena informações cadastrais dos clientes e seu estado de origem.

### `products`
Contém dados dos produtos e um campo `attributes`, permitindo flexibilidade para diferentes categorias.

### `orders`
Registra os pedidos realizados, incluindo os itens comprados e valores consolidados.

---

## Consulta de Negócio Escolhida

A consulta selecionada busca responder à seguinte pergunta:

**Quais são os 20 produtos mais populares por estado dos clientes?**

Essa consulta foi escolhida por exigir processamento analítico sobre grandes volumes de dados transacionais, utilizando o framework de agregação do MongoDB.

A solução utiliza:

- `$unwind` para decompor os itens dos pedidos
- `$group` para agregação por estado e produto
- `$sort` para ordenação por volume de vendas
- `$slice` para limitar aos 20 produtos mais relevantes

Essa abordagem permite análise estratégica de consumo regional e pode apoiar decisões logísticas e comerciais.