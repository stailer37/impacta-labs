# Caso de Estudo Amazonas - Análise de Dados de E-commerce

## 1. Integrantes do Grupo
- Alex Fructo
- Ivan Aldecoa Rosseto
- Luiz Fernando Zanco
- Marcos Kuniyoshi
- Yuri Alves Novaes

## 2. Estrutura do Repositório

```
impacta-labs/
└── feat/grupo3_2025_mba_de_07/
    └── src/
        ├── gera_produtos.py
        ├── gera_clientes.py
        ├── gera_vendas.py
    ├── README.MD
    ├── clientes.json
    ├── produtos.json
    ├── vendas.json
    ├── .gitignore
    ├── requirements.txt
    └── command_mongo.sh
```



## 3. Sumário Executivo

Este documento detalha a arquitetura de dados proposta para a Amazonas, empresa de e-commerce que necessita acompanhar fluxos de cliques e rastrear compras de clientes. A solução foi desenvolvida considerando escalabilidade, performance e flexibilidade para futuras expansões.

## 4. Arquitetura de Dados

### Decisões Arquiteturais Principais

#### 1. **Estrutura de Coleções**
Optamos por **3 coleções principais** com relacionamentos bem definidos:

| Coleção | Propósito | Principais Campos |
|---------|-----------|-------------------|
| **clientes** | Dados demográficos e comportamentais | cliente_id, endereco, cliques_recentes |
| **produtos** | Catálogo de produtos | produto_id, categoria, preco, estoque |
| **vendas** | Transações comerciais | venda_id, itens[], valor_total, estado_cliente |

**Justificativa**: 
- **Normalização adequada**: Evita duplicação de dados enquanto mantém performance
- **Escalabilidade**: Novas categorias de produtos podem ser adicionadas sem alterar estrutura
- **Consultas otimizadas**: Cada coleção atende a um domínio específico de negócio

#### 2. **Embedding vs Referencing**
Utilizamos **embedding** para:
- `cliques_recentes` na coleção clientes
- `itens` na coleção vendas

**Justificativa**:
- **Performance**: Dados frequentemente acessados juntos estão colocalizados
- **Consultas mais simples**: Reduz necessidade de `$lookup` operations
- **Limite controlado**: `cliques_recentes` mantém apenas os últimos cliques

#### 3. **Indexação Estratégica**
Campos indexados para otimização:
- `estado_cliente` (vendas)
- `categoria` (produtos) 
- `data_venda` (vendas)
- `cliente_id` (vendas, clientes)

## 5. Eventos Sistêmicos Definidos

### Evento 1: `CLIENTE_CRIADO`
```json
{
  "evento_id": "cli_2024_001",
  "tipo": "CLIENTE_CRIADO",
  "timestamp": "2024-01-15T10:30:00Z",
  "dados": {
    "cliente_id": "C1001",
    "nome": "João Silva",
    "email": "joao.silva@email.com",
    "endereco": {
      "rua": "Av. Paulista, 1000",
      "cidade": "São Paulo",
      "estado": "SP",
      "cep": "01310-100"
    },
    "data_cadastro": "2024-01-15T10:30:00Z",
    "cliques_recentes": [
      {
        "produto_id": "P2001",
        "categoria": "livros",
        "timestamp": "2024-01-15T10:25:00Z"
      }
    ]
  }
}
```

**Propósito**: Rastrear criação de contas e dados demográficos para análise regional.

### Evento 2: `VENDA_REGISTRADA`
```json
{
  "evento_id": "vnd_2024_001",
  "tipo": "VENDA_REGISTRADA",
  "timestamp": "2024-01-15T11:45:00Z",
  "dados": {
    "venda_id": "V3001",
    "cliente_id": "C1001",
    "data_venda": "2024-01-15T11:45:00Z",
    "valor_total": 187.50,
    "itens": [
      {
        "produto_id": "P2001",
        "nome": "Dom Casmurro",
        "categoria": "livros",
        "preco_unitario": 35.90,
        "quantidade": 1
      },
      {
        "produto_id": "P1001",
        "nome": "CD Legião Urbana",
        "categoria": "cds",
        "preco_unitario": 29.90,
        "quantidade": 2
      }
    ],
    "estado_cliente": "SP"
  }
}
```

**Propósito**: Capturar transações completas com detalhamento por item para análise de vendas.

## 6. Respostas às Perguntas de Negócio

### 6.1. **Média de Produtos Comprados por Cliente**

**Abordagem Técnica**:
```javascript
db.vendas.aggregate([
  {
    $group: {
      _id: "$cliente_id",
      total_produtos: { $sum: { $size: "$itens" } }
    }
  },
  {
    $group: {
      _id: null,
      media_produtos: { $avg: "$total_produtos" }
    }
  }
])
```

**Estratégia**:
- Agrupa vendas por cliente calculando total de produtos por venda
- Calcula média geral across todos os clientes
- **Performance**: Utiliza aggregation pipeline nativo do MongoDB

### 6.2. **Top 20 Produtos Mais Populares por Estado**

**Abordagem Técnica**:
```javascript
db.vendas.aggregate([
  { $unwind: "$itens" },
  {
    $group: {
      _id: {
        estado: "$estado_cliente",
        produto_id: "$itens.produto_id"
      },
      total_vendido: { $sum: "$itens.quantidade" }
    }
  },
  {
    $sort: { "_id.estado": 1, "total_vendido": -1 }
  },
  {
    $group: {
      _id: "$_id.estado",
      produtos_populares: {
        $push: {
          produto_id: "$_id.produto_id",
          vendas: "$total_vendido"
        }
      }
    }
  },
  {
    $project: {
      top_20: { $slice: ["$produtos_populares", 20] }
    }
  }
])
```

**Estratégia**:
- `$unwind` para expandir array de itens
- Agrupamento duplo: primeiro por estado/produto, depois apenas por estado
- `$slice` para limitar a 20 produtos por estado
- **Performance**: Ordenação otimizada por índice de estado

### 6.3. **Valor Médio das Vendas por Estado**

**Abordagem Técnica**:
```javascript
db.vendas.aggregate([
  {
    $group: {
      _id: "$estado_cliente",
      media_vendas: { $avg: "$valor_total" },
      total_vendas: { $sum: "$valor_total" },
      quantidade_vendas: { $sum: 1 }
    }
  },
  {
    $sort: { "media_vendas": -1 }
  }
])
```

**Estratégia**:
- Agregação simples por estado
- Múltiplas métricas calculadas em única passada
- **Performance**: Índice em `estado_cliente` acelera agrupamento

### 6.4. **Vendas por Tipo de Produto (Últimos 30 Dias)**

**Abordagem Técnica**:
```javascript
db.vendas.aggregate([
  {
    $match: {
      "data_venda": {
        $gte: ISODate("2024-01-01T00:00:00Z"),
        $lte: ISODate("2024-01-30T23:59:59Z")
      }
    }
  },
  { $unwind: "$itens" },
  {
    $group: {
      _id: "$itens.categoria",
      total_vendido: { $sum: "$itens.quantidade" },
      valor_total: { $sum: { $multiply: ["$itens.preco_unitario", "$itens.quantidade"] } }
    }
  },
  {
    $sort: { "total_vendido": -1 }
  }
])
```

**Estratégia**:
- `$match` inicial para filtrar por período (índice otimizado)
- `$unwind` para trabalhar com itens individualmente
- Agrupamento por categoria com cálculos de quantidade e valor

## 7. Justificativas Detalhadas das Decisões

### 7.1. **Escolha do MongoDB**

**Vantagens Aproveitadas**:
- **Schema flexibility**: Facilita adição de novas categorias de produtos
- **Aggregation framework**: Poderoso para análises complexas
- **Document model**: Natural para dados de e-commerce (pedidos com itens)
- **Performance**: Índices e agregações otimizadas

### 7.2. **Normalização Balanceada**

**Princípio**: Nem máxima normalização (muitos joins), nem denormalização completa (duplicação)

**Benefícios**:
- **clientes**: Dados mestres separados para integridade
- **produtos**: Catálogo centralizado para consistência de preços/estoque
- **vendas**: Transacionais com embedding para performance

### 8. **Extra - Gerar dados**

- **Clientes (`gerar_clientes.py`)**  
  Responsável por criar registros de clientes no arquivo `clientes.json`.

- **Produtos (`gerar_produtos.py`)**  
  Responsável por criar registros de produtos no arquivo `produtos.json`.

- **Vendas/Eventos (`gerar_vendas.py`)**  
  Responsável por gerar eventos de vendas no arquivo `vendas.json`, utilizando clientes e produtos já cadastrados.

### Como executar

Após criar o ambiente virtual e instalar as dependências de requirements.txt, execute:

1. Gere os produtos:
   ```bash
   python ./src/gera_produtos.py

2. Gere os clientes:
   ```bash
   python ./src/gera_clientes.py

3. Gere as vendas:
   ```bash
   python ./src/gera_vendas.py

## 9. Conclusão

A arquitetura proposta para a Amazonas equilibra eficientemente as necessidades atuais de negócio com flexibilidade para expansão futura. Através de:

1. **Coleções especializadas** que organizam dados por domínio
2. **Estratégia de embedding inteligente** que balanceia performance e normalização
3. **Agregações otimizadas** que respondem diretamente às perguntas de negócio
4. **Estrutura extensível** que acomodará novos produtos e funcionalidades

Esta solução permitirá à Amazonas não apenas responder às questões atuais de forma eficiente, mas também escalar para análises mais complexas conforme o negócio cresce. A abordagem baseada em documentos do MongoDB prova-se ideal para o domínio de e-commerce, onde dados semi-estruturados e relações complexas são comuns.