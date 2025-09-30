# Estudo de Caso Amazonas - Análise de Dados em E-commerce

- Igor Pires de Felipe  

---

## 3. Visão Geral

Este relatório apresenta a arquitetura de dados proposta para a empresa fictícia **Amazonas**, do ramo de e-commerce, que precisa monitorar cliques de usuários e registrar as compras realizadas. O projeto foi construído visando escalabilidade, desempenho e flexibilidade para suportar futuras necessidades de crescimento.

---

## 4. Arquitetura de Dados

### Principais Decisões de Arquitetura

#### 1. **Coleções Definidas**
Foram estabelecidas **três coleções principais**, cada uma com um domínio claro:

| Coleção     | Objetivo                           | Campos Relevantes |
|-------------|------------------------------------|-------------------|
| **clientes** | Informações demográficas e de navegação | cliente_id, endereco, cliques_recentes |
| **produtos** | Catálogo com dados de produtos    | produto_id, categoria, preco, estoque |
| **vendas**   | Registro das transações           | venda_id, itens[], valor_total, estado_cliente |

**Motivos da escolha**:
- Normalização equilibrada: reduz redundâncias sem comprometer a performance.  
- Escalabilidade: novos produtos e categorias podem ser adicionados sem alterar a estrutura atual.  
- Consultas otimizadas: cada coleção atende a um contexto de negócio específico.  

#### 2. **Uso de Embedding vs Referencing**
Optou-se por utilizar **embedding** em:
- `cliques_recentes` dentro de clientes  
- `itens` dentro de vendas  

**Razões**:
- Eficiência: informações consultadas em conjunto ficam armazenadas no mesmo documento.  
- Menos joins: diminui a necessidade de `$lookup`.  
- Controle: em `cliques_recentes`, apenas os últimos registros são guardados.  

#### 3. **Indexação Planejada**
Índices definidos para melhorar performance:  
- `estado_cliente` (coleção vendas)  
- `categoria` (coleção produtos)  
- `data_venda` (coleção vendas)  
- `cliente_id` (vendas e clientes)  

---

## 5. Eventos Modelados

### Exemplo 1: `CLIENTE_CRIADO`
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

**Finalidade**: registrar novos cadastros e associar dados regionais.  

---

### Exemplo 2: `VENDA_REGISTRADA`
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

**Finalidade**: consolidar transações detalhadas por item e região.  

---

## 6. Questões de Negócio Respondidas

### 6.1. Média de Produtos Comprados por Cliente
- Agregação por cliente somando o número de itens adquiridos.  
- Cálculo da média total com `aggregation pipeline`.  

### 6.2. Top 20 Produtos Mais Vendidos por Estado
- Uso de `$unwind` para expandir itens.  
- Agrupamento por estado e produto.  
- Aplicação de `$slice` para retornar apenas os 20 mais vendidos em cada estado.  

### 6.3. Ticket Médio das Vendas por Estado
- Agregação direta em `valor_total`.  
- Cálculo de média, soma total e quantidade de vendas.  

### 6.4. Vendas por Categoria (últimos 30 dias)
- Filtro inicial por data (`$match`).  
- Agrupamento por categoria com valores e quantidades.  
- Ordenação para destacar os mais vendidos.  

---

## 7. Motivações das Escolhas

### 7.1. Uso do MongoDB
- Flexibilidade de schema: facilita inserção de novas categorias.  
- Framework de agregação: robusto para análises complexas.  
- Modelo de documentos: adequado para e-commerce.  
- Performance: consultas rápidas com índices bem definidos.  

### 7.2. Normalização Balanceada
- Evita tanto excesso de joins quanto redundâncias exageradas.  
- Estrutura clara:  
  - **clientes** → dados mestres  
  - **produtos** → catálogo centralizado  
  - **vendas** → registros transacionais  

---
Conclusão

A solução desenvolvida para a **Amazonas** garante um equilíbrio entre desempenho atual e capacidade de evolução futura. Seus pontos fortes:  

1. **Coleções organizadas por domínio**  
2. **Embedding estratégico** para aumentar a eficiência  
3. **Agregações otimizadas** para responder perguntas de negócio rapidamente  
4. **Modelo expansível** preparado para novos produtos e funcionalidades  

Com essa abordagem, a empresa terá uma base sólida para análises em tempo real e futuras evoluções, aproveitando ao máximo as vantagens do MongoDB.  
