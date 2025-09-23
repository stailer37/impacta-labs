# 🚀 Caso de Estudo NoSQL - Amazonas E-commerce

-----

## 👥 Integrantes do Grupo

| Nome | 
| :--- | 
| **Gabriel Morais Simonini Sussmann** |
| **Bruno Boggio** |
| **Nelson Francisco Valerio dos Reis** |
| **Denis Varela** |

-----

## 🏗️ Decisões de Arquitetura

Neste projeto, optamos por uma arquitetura de dados baseada em **três coleções separadas** no MongoDB para otimizar a performance, flexibilidade e manutenibilidade.

### 🗄️ Estrutura de Collections

| Collection | Descrição Principal | Foco da Otimização |
| :--- | :--- | :--- |
| **`customers`** | Dados cadastrais e geográficos dos clientes. | Consultas sobre perfis de usuário. |
| **`products`** | Catálogo completo de itens com detalhes por categoria. | Facilidade na manutenção do catálogo e flexibilidade de esquema. |
| **`events`** | Registros de cliques e transações de compra. | Análises temporais e rastreamento de comportamento. |

### 💡 Justificativas das Decisões

#### 1\. Por que a Desnormalização Estratégica?

  - **`Customers` Collection:** Contém dados estáveis do cliente. Permite **normalização** de dados geográficos (como o estado) para manter a integridade e facilitar consultas analíticas por região.
  - **`Products` Collection:** Sua estrutura flexível (**esquema *schema-less***) é ideal para um e-commerce com diversos tipos de produtos (livros, CDs, eletrodomésticos), facilitando a adição de novos campos específicos sem alterar o esquema principal.
  - **`Events` Collection:** Projetada para **escrita intensiva**. Armazenar eventos separados é crucial para análises de *funil de vendas* e *comportamento do usuário*, sendo otimizada para consultas temporais (séries temporais).

#### 2\. Vantagens da Abordagem Escolhida

| Benefício | Descrição |
| :--- | :--- |
| **Escalabilidade** | Coleções separadas permitem **indexação** e **sharding** independentes, garantindo que o crescimento de uma coleção não impacte a performance das outras. |
| **Flexibilidade** | O esquema permite a fácil adição de novos tipos de produtos ou eventos. |
| **Performance** | Consultas otimizadas, pois cada *query* mira em uma coleção específica, reduzindo o *scan* de documentos irrelevantes. |
| **Manutenibilidade** | Estrutura clara e organizada, facilitando a compreensão e o gerenciamento do banco de dados. |

-----

## 📊 Consulta de Exemplo

A principal consulta escolhida para demonstrar a modelagem analítica é:

> **Calcular o valor médio de vendas por estado.**
>
> ➡️ *Consulte o arquivo **`command_mongo.sh`** para ver o pipeline de agregação completo.*

-----

## 🛠️ Passo a Passo de Execução (VS Code / Docker)

Siga os passos abaixo para configurar e rodar o projeto em seu ambiente local.

### 1\. 🐳 Configuração e Build do Docker

Navegue para a pasta `no-sql-databases/case_nosql_oficial/mongodb` e execute:

```bash
# Constrói a imagem Docker do MongoDB
docker build -t case_mongodb .
```

### 2\. 🚀 Iniciando o Container

Inicie o container do MongoDB, mapeando a porta `27017`:

```bash
# Inicia o container em modo 'detached'
docker run -d -p 27017:27017 --name mongodb_case case_mongodb
```

### 3\. 📥 Importando os Documentos

Copie os arquivos `.json` de dados para dentro do container:

```bash
docker cp customers.json mongodb_case:/customers.json
docker cp events.json mongodb_case:/events.json
docker cp products.json mongodb_case:/products.json
```

Em seguida, execute os comandos de importação para popular as collections:

```bash
docker exec -it mongodb_case mongoimport --db test --collection customers --file /customers.json --type json --legacy
docker exec -it mongodb_case mongoimport --db test --collection events --file /events.json --type json --legacy
docker exec -it mongodb_case mongoimport --db test --collection products --file /products.json --type json --legacy
```

### 4\. 🔬 Executando a Consulta

Acesse o *shell* do MongoDB dentro do container e execute a *query* analítica:

```bash
# Acesse o mongosh
docker exec -it mongodb_case mongosh

# Dentro do mongosh, execute o código de agregação do arquivo command_mongo.sh



