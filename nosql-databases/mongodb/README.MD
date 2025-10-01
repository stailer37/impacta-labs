## 1. Componentes do Grupo

- Caio Macedo Santos. RA: 2502444
- Gabriel Gonçalves Cruvinel. RA: 2502454

## 2 Introdução
   Propor arquitetura de solução de organização de dados MongoDB, visando um suporte a analytics e escalabilidade do processo.

### 2.1 Proposta de solução 
   Possuir uma coleção múltiplas eventos, pedidos e produtos.
   - Produtos: Um unico local de cadastro de produtos, que irão possuir uma categoria (category) e atributos especificos (attrs). Devido a possibilidade de expansão dos produtos fornecidos para venda, a centralização de produtos possibilita uma ampliação mais simples.
   - Pedidos: Documento por pedido, agregando os itens pedidos pelo cliente. Como motivação destacamos uma necessidade de acesso constante a essa coleção, possibilitando uma leitura por pedido e por cliente, também entrega uma possibilidade de agregação por estado/itens. 
   - Eventos: Armazenar ações dos clientes. Como motivação dessa coleção, destacamos um possível alto volume de informações, uma possibilidade de esquema flexivel e times-series
   

### 2.2 Proposta de esquema
2.2.1. Produtos
```json
   {
      _id: ObjectId(),
      sku: "BK-978853252",                 // identificador único para relações
      name: "Engenharia de Dados na Prática", 
      category: "book",                    // Categoria do produto
      brand: "Decifrando Arquiteturas de Dados",             // Campo comum 
      price: { amount: 129.90, currency: "BRL" },
      status: "ativo",                    // ativo | inativo
      attrs: {                             // específicos por categoria
         // book
         author: "James Serra",
         isbn: "9788575229217...",
         pages: 294,
         language: "pt-BR",
         publisher: "O'REILLY"
      },
      created_at: ISODate("2025-09-24T12:00:00Z"),
      updated_at: ISODate("2025-09-24T12:00:00Z"),
      schemaVersion: 1
      }
   ```
   - Campos utilizados:
      - _id: Objeto gerado pelo MongoDB;
      - sku: Indicador de integração, utilizado para as relações;
      - name: Nome exibido ao cliente e usado em buscas;
      - category: Caracteriza o tipo de produto, fazendo a segmentação de regras e atributos, o que facilita filtros e relatórios;
      - brand: Marca/Fabricante, util quando aplicados filtros;
      - price.amount: Preço atual do produto
      - price.currency: Moeda do produto;
      - status: Pode ser active ou inactive, faz com que tenhamos um controle de exposição sem necessariamente excluir o produto;
      - attrs: Campos específicos por categoria, possibilita um detalhamento para cada tipo de produto;
      - created_at: criação do registro a nível de auditoria;
      - schemaVersion: Em caso de necessidade de evolução do schema, essa variavel acompanha seu crescimento
   - Campo de attrs:
      - Livros (category = "book")
         - author  Kitana Ferreira
         - isbn  978853252...
         - pages 384
         - language  pt-BR
         - publisher Casa do Código
         - edition 2ª
         - publication_year  2024
      - CDs (category = "cd")
         - artist  Pandora 
         - label Mitologia Records
         - tracks   ["Intro","Hit Single"]
         - release_year 2021
         - genre string  Rock
      - Eletrodomesticos de cozinha (category = "kitchen_appliance)
         - power_watts  900
         - voltage  110/220
         - color  preto
         - dimensions_cm { "w": 20, "h": 30, "d": 25 }
         - weight_kg 2.4
         - material inox

   - Motivação de escolha do schema:
      - Devido a possibilidade de expansão de produtos ofertados, essa estrutura provem uma escalabilidade mais simples dos produtos oferecidos. Um catalogo único de produtos evita N coelções e multiplos códigos repetidos para busca, preço, promoções.
      - Proporciona uma flexibilidade sem compromoter a legibilidade;
      - Indexação simples com sku, category, status. Caso existam muitas caterias, a principio, não seria necessaria uma reindexação;
      - Polimorfismo controlado, campos comuns (sku, name, brand, price, status) possuindo um bloco atrrs para o que é especifico de cada categoria.

2.2.2. Pedidos
```json
{
  _id: ObjectId(),
  order_id: "AMZ-2025-00001234",       // id externo
  customer_id: "cust_9f2a...",
  customer_state: "SP",                // denormalizado p/ analytics por UF
  created_at: ISODate("2025-09-25T14:03:21Z"),
  status: "paid",                      // paid | cancelled | refunded | ...
  payment: { method: "credit_card", value: 259.80, currency: "BRL" },
  items: [
    {
      product_id: ObjectId("..."),     // referencia products._id
      sku: "BK-978853252",             // denormalizado p/ auditoria e joins offline
      name: "Engenharia de Dados na Prática",
      category: "book",
      unit_price: 129.90,
      qty: 1
    },
    {
      product_id: ObjectId("..."),
      sku: "CD-000123",
      name: "Greatest Hits",
      category: "cd",
      unit_price: 129.90,
      qty: 1
    }
  ],
  schemaVersion: 1
}
```
   - Campos utilizados:
      - _id: Identificador do mongo
      - order_id: Id extreno de identificação do pedido 
      - customer_id: Identificador de cliente, pode ser utilizado para analise por cliente   
      - customer_state: Identificador de UF do cliente, visando uma simplificação na modelagem, sem necessidade de join
      - created_at: Data da criação do pedido  
      - status: Atualiza conforme o fluxo do pedido. Fluxo: created -> paid -> shipped -> delivered (cancelled/refunded)   
      - payment.method: Meio de pagamento
      - payment.value: Valor final do pedido
      - payment.currency: Moeda de pagamento
      - items[]: Linhas do pedido
      - schemaVersion: Em caso de necessidade de evolução do schema, essa variavel acompanha seu crescimento
   - Campos dos itens(items[]):
      - product_id:  Serve como referencia do produto
      - sku: índice auxiliar em items.sku, para acelerar consultas por item
      - name: Nome do produto no ato da compra, em caso de mudança, servirá como histórico
      - category: Categoriad e acordo com catálogo
      - unit_price: Preço no ato da compra, o que possibilita um acompanhamento da evoluçaõ os valores  
      - qty: Quantidade comprada do item.
   - Motivação de escolha:
      - Como produtos são algo que ocorrem a todo tempo, itens embutidos agilizam as consultas;
      - Possibilita a resposta a perguntas de negocio de formas mais diretas.

2.2.3. Eventos
```json
{
  _id: ObjectId(),
  ts: ISODate("2025-09-25T14:00:05Z"),
  session_id: "sess_4a9c...",
  customer_id: "cust_9f2a...",         // pode ser null/anon
  customer_state: "SP",                // se conhecido; útil p/ funil por UF
  type: "product_view",                // page_view | product_view | add_to_cart | checkout | purchase | ...
  product: {                           // presente quando aplicável
    product_id: ObjectId("..."),
    sku: "BK-978853252",
    category: "book"
  },
  page: { url: "/produto/BK-978853252", referrer: "/busca?..." },
  device: { ua: "...", platform: "web" },
  meta: { ab_test: "search_v2" },
  schemaVersion: 1
}
```
   - Campo eventos:
      - _id: Identificador nativo, para poder ser utilizado como um event_id 
      - ts: TimesTamp do evento
      - session_id: Identificador da sessão do um usuário e sua sessão
      - customer_id: Identificador do cliente
      - customer_state: Identificador da UF do cliente
      - type: Indicador da intenção do cliente, se só view, adicionou ao carrinho ou comprou
      - product: Identifica o produto, quando visto pelo cliente
      - page: Páginas que o cliente entrou
      - device: Identifica o dispositivo de acesso, mobile, device, browser
      - meta: Campo que tenta identificar o metodo de captura do cliente em questão
      - schemaVersion
   - Motivação de escolha:
      - Para que possamos rastrear o que o cliente faz em nosso e-comerce, visando futuras sugestões de produtos;
      - Essa estrutura permite um rastreio da vida do cliente, que fornece insumos para entendimento de desistências. 

## 3. Perguntas de negócio

> Quais são os 20 produtos mais populares por estado dos clientes?
```json
{
    _id: 'GO',
    top20: [
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a0e'),
        sku: 'CD-000128',
        name: 'Electro Dataflow',
        total_qty: 3
      },
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a08'),
        sku: 'BK-9788576082676',
        name: 'Arquitetura de Dados Moderna',
        total_qty: 1
      },
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a12'),
        sku: 'KT-000991',
        name: 'Espremedor Turbo Citrus',
        total_qty: 1
      }
    ]
  },
  {
    _id: 'PR',
    top20: [
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a05'),
        sku: 'BK-9788576082675',
        name: 'Data Warehouse: Conceitos e Projetos',
        total_qty: 1
      },
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a0d'),
        sku: 'CD-000127',
        name: 'Rock for Engineers',
        total_qty: 1
      },
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a11'),
        sku: 'KT-000990',
        name: 'Torradeira Inox 4 Fatias',
        total_qty: 1
      }
    ]
  },
  {
    _id: 'CE',
    top20: [
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a0a'),
        sku: 'CD-000124',
        name: 'Acoustic Sessions',
        total_qty: 1
      }
    ]
  },
  {
    _id: 'PE',
    top20: [
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a14'),
        sku: 'CD-000129',
        name: 'Bossa Nova Essentials',
        total_qty: 2
      },
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a09'),
        sku: 'BK-9788575229781',
        name: 'Spark: O Guia Definitivo',
        total_qty: 1
      },
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a04'),
        sku: 'BK-9788550804601',
        name: 'MongoDB em Ação',
        total_qty: 1
      }
    ]
  },
  {
    _id: 'RJ',
    top20: [
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a02'),
        sku: 'CD-000123',
        name: 'Greatest Hits',
        total_qty: 1
      },
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a03'),
        sku: 'KT-000987',
        name: 'Liquidificador Turbo 900W',
        total_qty: 1
      }
    ]
  },
  {
    _id: 'SC',
    top20: [
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a13'),
        sku: 'KT-000992',
        name: 'Forno Micro-ondas Smart 30L',
        total_qty: 1
      }
    ]
  },
  {
    _id: 'MG',
    top20: [
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a01'),
        sku: 'BK-9788575229217',
        name: 'Engenharia de Dados na Prática',
        total_qty: 1
      },
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a03'),
        sku: 'KT-000987',
        name: 'Liquidificador Turbo 900W',
        total_qty: 1
      }
    ]
  },
  {
    _id: 'SP',
    top20: [
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a01'),
        sku: 'BK-9788575229217',
        name: 'Engenharia de Dados na Prática',
        total_qty: 1
      },
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a02'),
        sku: 'CD-000123',
        name: 'Greatest Hits',
        total_qty: 1
      }
    ]
  },
  {
    _id: 'BA',
    top20: [
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a0f'),
        sku: 'KT-000988',
        name: 'Cafeteira Programável 20x',
        total_qty: 1
      }
    ]
  },
  {
    _id: 'RS',
    top20: [
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a07'),
        sku: 'BK-9788576081739',
        name: 'Python para Análise de Dados',
        total_qty: 1
      },
      {
        product_id: ObjectId('66f8a1111a2b3c4d5e6f7a0b'),
        sku: 'CD-000125',
        name: 'Lo-Fi Coding Beats',
        total_qty: 1
      }
    ]
  }
```

> Qual é o valor médio das vendas por estado do cliente?
```json
  { total_orders: 1, state: 'BA', avg_sales: 329.9 },
  { total_orders: 1, state: 'CE', avg_sales: 34.9 },
  { total_orders: 1, state: 'GO', avg_sales: 459.8 },
  { total_orders: 1, state: 'MG', avg_sales: 349.8 },
  { total_orders: 1, state: 'PE', avg_sales: 271.9 },
  { total_orders: 1, state: 'PR', avg_sales: 363.9 },
  { total_orders: 1, state: 'RJ', avg_sales: 259.8 },
  { total_orders: 1, state: 'RS', avg_sales: 174.8 },
  { total_orders: 1, state: 'SC', avg_sales: 799 },
  { total_orders: 1, state: 'SP', avg_sales: 169.8 }
```

> Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?
```json
  { total_qty: 9, category: 'cd' },
  { total_qty: 7, category: 'book' },
  { total_qty: 6, category: 'kitchen_appliance' }
```