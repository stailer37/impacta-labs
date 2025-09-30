## 1. Decisões de Arquitetura e Modelagem de Dados

### A Escolha: Múltiplas Coleções

Para ajudar a Amazonas a crescer e entender seus clientes, pensei em como organizar os dados. A melhor forma de fazer isso é separando as informações em coleções diferentes.

**E por que isso é melhor?**

1.  **Tudo no lugar correto:** Os dados de **vendas** são como o "livro-caixa" da empresa: importantes e precisam estar bem organizados. Já os dados de **cliques** são como um rascunho de navegação, com um volume enorme de informações. Separar as coisas garante que, ao analisar as vendas, não seja preciso filtrar milhões de registros de cliques que não importam para aquela pergunta.

2.  **Respostas mais rápidas:** Após tudo organizado, para responder a pergunta  "Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?", o sistema vai direto na coleção de vendas e traz a resposta rapidamente.

3.  **Denormalização:** Usado para otimizar a performance de leitura. O campo state da coleção customers é embutido em cada documento da coleção orders no momento da escrita. Isso previne o uso de operações $lookup custosas, permitindo que as queries de agregação sejam resolvidas de forma mais eficiente em uma única coleção, o que reduz a latência de forma significativa."

### Estrutura das Coleções

#### a) `customers` (Clientes)
Armazena os documentos referentes a cada cliente cadastrado.

* `_id`: **ObjectId** - Chave primária da coleção, indexada por padrão, que identifica unicamente cada documento de cliente.
* `name`: **String** - Nome completo do cliente.
* `email`: **String** - Endereço de e-mail do cliente. 
* `state`: **String** - Sigla do estado de residência do cliente (e.g., 'SP'). Campo chave para agregações e que será denormalizado em outras coleções.
* `registrationDate`: **Date** - Timestamp que armazena a data de cadastro do cliente.

#### b) `products` (Produtos)
Armazena o catálogo de produtos disponíveis para venda.

* `_id`: **ObjectId** - Chave primária da coleção, que identifica unicamente cada documento de produto.
* `name`: **String** - Nome de exibição do produto.
* `price`: **Decimal128** - Preço do produto.
* `description`: **String** - Descrição textual detalhada do produto.
* `category`: **String** - Categoria à qual o produto pertence (ex: 'book').

#### c) `orders` (Vendas)
Coleção transacional que armazena os pedidos realizados. Otimizada com denormalização para performance de leitura.

* `_id`: **ObjectId** - Chave primária da coleção, identificando unicamente cada pedido.
* `customerId`: **ObjectId** - Chave estrangeira que referencia o `_id` do documento na coleção `customers`.
* `customerState`: **String** - Campo denormalizado do documento `customer`.
* `timestamp`: **Date** - Timestamp da data de criação do pedido.
* `totalValue`: **Decimal128** - Campo denormalizado/calculado que armazena o valor total do pedido.
* `products`: **Array** de subdocumentos - Cada subdocumento representa um item do pedido e contém:
    * `productId`: **ObjectId** - Referência ao `_id` do produto.
    * `name`, `category`, `price`: Campos denormalizados do produto para evitar `$lookup`s e manter um registro histórico do estado do produto no momento da compra.
    * `quantity`: **Int32** - Quantidade de unidades do produto neste pedido.

#### d) `clicks` (Cliques)
Coleção de eventos que armazena as interações de clique dos usuários.

* `_id`: **ObjectId** - Chave primária do documento de evento.
* `customerId`: **ObjectId** - Referência ao cliente que executou a ação.
* `productId`: **ObjectId** - Referência ao produto que foi alvo da ação.
* `timestamp`: **Date** - Timestamp exato da ocorrência do evento.
* `eventType`: **String** - Tipo de evento de interação (ex: 'product_view', 'add_to_cart'). Permite a segmentação para análises de comportamento do usuário.

---

## 2. Eventos Sistêmicos (Exemplos)

### Evento: `OrderPlaced` (Pedido Realizado)
Este evento seria gerado no momento em que um cliente finaliza uma compra. Um outro serviço ouviria este evento e usaria seu conteúdo (`payload`) para criar o documento na coleção `orders`.

```json
{
  "eventId": "evt_abc12345-6789-0123-4567-89abcdef0123",
  "eventName": "OrderPlaced",
  "eventTimestamp": "2025-09-29T14:30:00.000Z",
  "sourceService": "checkout-api",
  "payload": {
    "orderId": "ord_651633519c288f34f2d7890b",
    "customer": {
      "id": "cus_651633519c288f34f2d7890a",
      "state": "MG"
    },
    "totalValue": 749.90,
    "items": [
      {
        "productId": "prod_651633519c288f34f2d7890e",
        "name": "Batedeira planetária",
        "category": "small_appliance",
        "price": 699.90,
        "quantity": 1
      },
      {
        "productId": "prod_651633519c288f34f2d7890c",
        "name": "A Culpa é das Estrelas",
        "category": "book",
        "price": 50.00,
        "quantity": 1
      }
    ]
  }
}