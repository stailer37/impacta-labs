# E-commerce Amazonas

## Integrantes do Grupo `MarIsa`
- **Mar**io Piccin RA: 1801551
- **Isa**bela Silva RA:2500631

## Caso de Estudo

A empresa Amazonas do ramo de e-commerce deseja acompanhar os fluxos de cliques de seus clientes, bem como rastrear os produtos que eles compram.Neste momento, a empresa vende livros, CDs e pequenos eletrodomésticos de cozinha apenas, mas provavelmente irá expandir para outros produtos no futuro.
Amazonas quer ser capaz de responder às seguintes perguntas:

1. Qual é a média de produtos comprados por cliente?
2. Quais são os 20 produtos mais populares por estado dos clientes?
3. Qual é o valor médio das vendas por estado do cliente?
4. Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?

Vocês foram contratados para decidir qual a melhor maneira de organizar esses dados, seja em uma coleção única ou múltiplas, e devem definir quais campos específicos que cada produto deve ter e os porquês.
Devem produzir um ou mais eventos de sistêmicos no formato JSON para exemplificar as decisões.
Devem escolher uma das quatro perguntas de negócio e gerar um comando MongoDB para responder.

## Arquitetura de Dados

### Estratégia Escolhida: Duas Coleções Especializadas

Optamos por **duas coleções** especializadas para atender diferentes necessidades de negócio:

**Coleção `transactions`:**
- **Propósito**: Dados transacionais de compra para métricas de negócio
- **Frequência**: Baixa (apenas quando há compra)
- **Volume**: Moderado
- **Consultas**: Agregações complexas para relatórios

**Coleção `clickstream`:**
- **Propósito**: Rastreamento comportamental e fluxo de navegação
- **Frequência**: Muito alta (cada clique/interação)
- **Volume**: Muito alto
- **Consultas**: Análises de comportamento, funis de conversão, heatmaps

**Vantagens da Separação:**
- **Performance**: Consultas de clickstream não impactam relatórios de vendas
- **Escalabilidade**: Cada coleção pode ser otimizada independentemente
- **Índices**: Estratégias de indexação específicas para cada caso de uso

#### Estrutura de Campos - Coleção `transactions`

**Campos do Cliente:**
- `customer_id`: Identificação única do cliente
- `customer_name`: Nome completo do cliente (para personalização e suporte)
- `customer_email`: Email do cliente (comunicação e identificação secundária)
- `customer_state`: Estado do cliente (essencial para 2 das 4 perguntas propostas)
- `customer_city`: Cidade (para análises geográficas detalhadas)
- `customer_segment`: Segmento do cliente (novo, recorrente, VIP - para análises de retenção)

**Por que incluir dados do cliente nas transações?**
**Vantagens:**
- **Performance**: Consultas mais rápidas sem JOINs complexos
- **Disponibilidade**: Dados essenciais sempre acessíveis mesmo se sistema de clientes estiver indisponível
- **Simplicidade**: Queries diretas para todas as métricas de negócio
- **Histórico**: Preserva estado do cliente no momento da compra

**Campos Essenciais Incluídos:**
- **Nome e Email**: Para relatórios personalizados e suporte ao cliente
- **Localização**: Fundamental para as consultas com análises por região
- **Segmento**: Análises de retenção e valor do cliente

**Dados NÃO Incluídos (mantidos em sistema separado):**
- Senha e dados sensíveis de autenticação
- Histórico de endereços detalhado
- Preferências complexas de usuário
- Dados de pagamento (PCI compliance)

**Consistência de Dados:**
- Dados críticos (nome, email) podem ser atualizados via triggers ou batch jobs
- Dados analíticos (segmento) podem ter pequena latência aceitável
- Estado/cidade raramente mudam, baixo risco de inconsistência

**Campos da Transação:**
- `transaction_id`: ID único da transação
- `transaction_date`: Data/hora da compra (crucial para análise dos últimos 30 dias)
- `total_amount`: Valor total da compra

**Campos dos Produtos:**
- `products`: Array de produtos comprados (um cliente pode comprar múltiplos itens)
- Cada produto contém:
  - `product_id`: ID único do produto
  - `name`: Nome do produto
  - `category`: Categoria (livros, CDs, eletrodomésticos)
  - `price`: Preço unitário
  - `quantity`: Quantidade comprada

**Campos de Controle:**
- `_id`: Identificador único do documento no MongoDB (ObjectId gerado automaticamente)
- `created_at`: Timestamp de criação do registro (auditoria e troubleshooting)
- `updated_at`: Timestamp da última modificação (controle de versão e sincronização)

#### Estrutura de Campos - Coleção `clickstream`

**Campos do Evento:**
- `event_id`: ID único do evento
- `session_id`: ID da sessão do usuário
- `customer_id`: ID do cliente (se logado, pode ser null para usuários anônimos)
- `anonymous_id`: ID para rastreamento de usuários não logados
- `event_timestamp`: Timestamp preciso do evento
- `event_type`: Tipo do evento (page_view, product_click, add_to_cart, search, purchase, etc.)

**Campos de Contexto:**
- `page_url`: URL da página atual
- `page_title`: Título da página (SEO e análise de conteúdo)
- `previous_page`: URL da página anterior
- `user_agent`: Informações do navegador
- `ip_address`: IP do usuário (para geolocalização)

**Campos de Marketing:**
- `utm_source`: Fonte do tráfego (google, facebook, email)
- `utm_medium`: Meio de marketing (organic, cpc, social, email)
- `utm_campaign`: Campanha específica (para ROI de marketing)
- `referrer`: Site de origem do tráfego

**Campos de Produto (quando aplicável):**
- `product_id`: ID do produto clicado/visualizado
- `product_category`: Categoria do produto
- `search_query`: Termo de busca (se aplicável)
- `search_results_count`: Número de resultados encontrados (para análise de busca)

**Campos de Performance:**
- `session_duration`: Duração da sessão até o momento (em segundos)
- `page_load_time`: Tempo de carregamento da página (em segundos)
- `screen_resolution`: Resolução da tela (para análise de UX)

**Campos Específicos por Evento:**
- `transaction_id`: ID da transação (apenas para evento purchase)
- `purchase_value`: Valor da compra (apenas para evento purchase)

**Campos Técnicos:**
- `device_type`: mobile, desktop, tablet

**Campos de Controle:**
- `_id`: Identificador único do documento no MongoDB (ObjectId gerado automaticamente)
- `created_at`: Timestamp de criação do evento (essencial para ordenação temporal e debugging)

**Observação sobre updated_at em clickstream:**
- **Não utilizamos `updated_at`** na coleção clickstream pois eventos são **imutáveis** (write-once)
- Uma vez registrado, um clique não deve ser modificado, mantendo integridade do tracking
- Caso seja necessário corrigir um evento, o padrão é criar um novo evento de correção

#### Tratamento de Usuários Anônimos vs Autenticados

**Usuários Logados:**
- `customer_id`: Preenchido com ID do cliente
- `anonymous_id`: null

**Usuários Anônimos:**
- `customer_id`: null
- `anonymous_id`: ID único gerado para rastreamento (baseado em device fingerprint, IP, etc.)

**Conversão Anônimo → Autenticado:**
- Quando usuário faz login, eventos subsequentes passam a ter `customer_id`
- `anonymous_id` pode ser mantido para análise de jornada completa
- Permite conectar comportamento pré e pós login

#### Como responder as perguntas do negócio?

**Usando coleção `transactions`:**
- **P1. Qual é a média de produtos comprados por cliente?**: Group usando `$unwind` nos produtos + group por customer_id
- **P2. Quais são os 20 produtos mais populares por estado dos clientes?**: Group de estado + produto com count de vendas
- **P3. Qual é o valor médio das vendas por estado do cliente?**: Group de estado com average do total_amount
- **P4. Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?**: Filter por data + group por categoria

**Sugestões de análises usando a coleção `clickstream`:**
- **Funil de conversão**: page_view → product_click → add_to_cart → purchase
- **Taxa de abandono**: Análise de sessões que não resultaram em compra
- **Produtos mais visualizados**: Count de eventos product_view por produto
- **Jornada do cliente**: Sequência de eventos por session_id

**Análises Cross-Collection:**
- **Conversion rate**: Visualizações (clickstream) vs vendas (transactions)
- **Produtos com baixa conversão**: Muitas visualizações, baixa venda
- **Efetividade de busca**: Consultas realizadas vs compras

#### Considerações para Expansão Futura que é mencionada no caso de uso

**Para a coleção `transactions`:**
- **Novos tipos de produto**: Apenas adicionar novas categorias no campo `category`
- **Novos campos de produto**: Estrutura flexível permite campos específicos por categoria
- **Múltiplas moedas**: Adicionar campo `currency` para expansão internacional

**Para a coleção `clickstream`:**
- **Novos tipos de evento**: Fácil adição de event_types (wishlist, review, share)
- **Personalização**: Dados podem ser utilizados para enriquecimento de algoritmos de recomendação
- **Machine Learning**: Dados estruturados para modelos preditivos

## Indexação
A indexação é crucial no MongoDB pois acelera dramaticamente as consultas, evitando a varredura de cada documento de uma coleção, o que é altamente ineficiente. Sem índices, o MongoDB precisa percorrer todos os dados, enquanto um índice, uma estrutura de dados especial, permite encontrar documentos relevantes de forma rápida e direcionada. Embora melhore as consultas, um excesso de índices pode prejudicar as operações de escrita, sendo essencial um equilíbrio para otimizar o desempenho geral.  

### Índices para coleção `transactions`

#### **Índices Simples**

| Índice | Pergunta(s) Atendida(s) | Justificativa | Tipo de Operação |
|--------|-------------------------|---------------|------------------|
| `{ 'customer_state': 1 }` | **P2:** Top 20 produtos por estado<br>**P3:** Valor médio das vendas por estado | Filtragem e agrupamento por estado em múltiplas análises geográficas | `$match`, `$group` |
| `{ 'transaction_date': -1 }` | **P4:** Produtos vendidos nos últimos 30 dias<br>**Análises temporais** | Filtros por período (últimos X dias) - ordenação descendente para queries de período recente | `$match` com range de datas |
| `{ 'customer_id': 1 }` | **P1:** Média de produtos por cliente<br>**Análises de comportamento** | Agrupamento por cliente para métricas individuais e análises de retenção | `$group`, `$addToSet` |
| `{ 'customer_segment': 1 }` | **Segmentação de clientes**<br>**Análises de valor** | Filtragem e agrupamento por segmento (novo, recorrente, VIP) | `$match`, `$group` |
| `{ 'customer_email': 1 }` | **Lookup de clientes**<br>**Suporte ao cliente** | Busca rápida por cliente específico via email | `$match` exato |
| `{ 'products.category': 1 }` | **P2:** Top produtos por estado<br>**P4:** Produtos por categoria nos últimos 30 dias | Filtragem e agrupamento por categoria de produto após `$unwind` | `$match`, `$group` em arrays |
| `{ 'products.product_id': 1 }` | **P2:** Top produtos por estado<br>**Cross-collection:** Conversion rate | Identificação de produtos específicos após `$unwind` para análises detalhadas | `$match`, `$group` em arrays |

#### **Índices Compostos**

| Índice          | Pergunta(s) Atendida(s) | Justificativa | Benefício |
|-----------------|-------------------------|---------------|-----------|
| `{ 'customer_state': 1, 'transaction_date': -1 }` | **Análises geográficas temporais**<br>Ex: Vendas por estado no último trimestre | Combinação de filtro geográfico + temporal em uma única operação | Evita multiple index scan |
| `{ 'customer_segment': 1, 'customer_state': 1 }` | **Segmentação regional**<br>Ex: Clientes VIP por estado | Análise cruzada de segmento de cliente com localização | Suporte a queries multidimensionais |
| `{ 'transaction_date': -1, 'products.category': 1 }` | **P4 otimizada:** Produtos por categoria em período específico | Filtro temporal seguido de agrupamento por categoria | Pipeline eficiente para queries temporais + categoria |

---

### Índices para coleção `clickstream`

#### **Índices Simples**

| Índice | Pergunta(s) Atendida(s) | Justificativa | Tipo de Operação |
|--------|-------------------------|---------------|------------------|
| `{ 'event_timestamp': -1 }` | **Análises temporais**<br>**Ordenação cronológica** | Queries por período (últimos X dias/horas) e ordenação de eventos | `$match` range, `$sort` |
| `{ 'customer_id': 1, 'event_timestamp': -1 }` | **Jornada do cliente**<br>**Sequência de eventos por usuário** | Buscar todos eventos de um cliente específico ordenados por tempo | Compound query otimizada |
| `{ 'session_id': 1 }` | **Análise de sessões**<br>**Taxa de abandono** | Agrupamento de eventos por sessão para calcular funis e abandonos | `$group`, `$match` |
| `{ 'event_type': 1 }` | **Funil de conversão**<br>**Métricas por tipo de evento** | Filtragem por tipo de evento específico (page_view, purchase, etc.) | `$match`, `$group` |
| `{ 'product_id': 1 }` | **Produtos mais visualizados**<br>**Cross-collection:** Conversion rate | Análise de produtos específicos no clickstream | `$match`, `$group` |
| `{ 'product_category': 1 }` | **Funil por categoria**<br>**Interesse por categoria** | Agrupamento de eventos por categoria de produto | `$group`, `$match` |

**Índices para Marketing e Analytics**

| Índice | Pergunta(s) Atendida(s) | Justificativa | Benefício Específico |
|--------|-------------------------|---------------|---------------------|
| `{ 'utm_source': 1, 'utm_medium': 1 }` | **Performance de marketing por canal UTM**<br>**ROI por campanha** | Análise de efetividade de canais de marketing | Attribution modeling |
| `{ 'event_type': 1, 'product_category': 1 }` | **Funil de conversão por categoria**<br>**Eventos específicos por categoria** | Combinação de tipo de evento com categoria para análises detalhadas | Pipeline otimizado |
| `{ 'session_id': 1, 'event_timestamp': 1 }` | **Jornada temporal da sessão**<br>**Duração de sessão** | Ordenação de eventos dentro de cada sessão | Análise comportamental |

**Índice TTL (Time To Live)**

| Índice TTL | Função | Configuração | Benefício |
|------------|--------|--------------|-----------|
| `{ 'event_timestamp': 1, expireAfterSeconds: 7776000 }` | **Limpeza automática de dados antigos** | Remove documentos após 90 dias | Gestão automática de storage, compliance LGPD |


## Configurando o ambiente
Antes de iniciar o desenvolvimento do caso de uso, é necessário preparar o ambiente para garantir que todas as dependências estejam corretamente instaladas e que a conexão com o MongoDB funcione de forma adequada.

### 
1. Para clonar o repositório com o container utilizado no caso de uso, execute o seguinte comando:
```bash
git clone https://github.com/stailer37/impacta-labs.git  
````
2. Para construir a imagem, navegue para a pasta **impacta-labs/nosql-databases/mongodb** e execute o seguinte comando:
```bash
docker build -t impacta_labs_mongodb .
```
3. Para iniciar o container, execute o seguinte comando:
```bash
docker run -d -p 27017:27017 --name mongodb-standalone impacta_labs_mongodb
```
4. Para acessar o shell do MongoDB, execute o seguinte comando:   
```bash  
docker exec -it mongodb-standalone mongosh
```
5. Para navegar no banco de dados, execute o seguinte comando:
```bash
db
```
6. Para exibir as coleções do banco de dados, execute o seguinte comando:
```bash
show collections
```
7. Para sair do shell do MongoDB, execute o seguinte comando:
```bash
exit
```
8. Artefatos do caso de uso.
```bash
caso_estudo_marisa/
├── command_mongo.sh
├── collection_transactions.json  
├── collection_clickstream.json
└── README.md
```
9. Para executar o arquivo command_mongo.sh, execute o seguinte comando:
```bash
chmod +x command_mongo.sh
./command_mongo.sh
```
## Pergunta de negócio escolhida
- P1. Qual é a média de produtos comprados por cliente?

### Consulta para responder.
```bash
docker exec -i mongodb-standalone mongosh test --eval '
db.transactions.aggregate([

  // 1) Explode o array de produtos
  { $unwind: "$products" },

  // 2) Agrega por cliente e soma quantidade de produtos
  {
    $group: {
      _id: "$customer_id",
      total_products: { $sum: "$products.quantity" }
    }
  },

  // 3) Calcula a média de produtos por cliente
  {
    $group: {
      _id: null,
      avg_products_per_customer: { $avg: "$total_products" }
    }
  },

  // 4) Projeta a saída final com arredondamento
  {
    $project: {
      _id: 0,
      media_produtos_comprados_por_cliente: { $round: ["$avg_products_per_customer", 2] }
    }
  }
]).forEach(printjson);
'
```
