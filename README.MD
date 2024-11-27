# Grupo Bradesco
😄😄 Só o trabalho pode produzir riqueza - RISOS 😄😄

### Nomes

- Bianca Santos Carneiro - ``Bia``
- Fernando Tarrone Molina - ``Nando``
- Guilherme Masao Tsuyukubo - ``Japa``

## 1. Fundamentos do MongoDB

### 1.1 Introdução 
Nosso primeiro passo será nos familiarizar com os componentes principais do MongoDB, ajudando você a entender seu propósito e como interagir com eles.

Ao longo deste laboratório, você interagirá com uma instalação _standalone_ do MongoDB. Em ambientes de produção, você provavelmente ira intergir com um _deploy_ mais completo.

### 1.2 Componentes  
Os componentes principais do MongoDB são:

- [**mongosh**]("https://www.mongodb.com/pt-br/docs/mongodb-shell/"): O próprio shell do MongoDB, uma interface interativa em JavaScript e Node.js que você pode usar para se conectar e executar comandos.
- **mongod**: O processo principal (daemon), o processo central do sistema MongoDB.
- **mongos**: O processo que direciona consultas e operações de escrita em um cluster fragmentado.
  
Há também as **Ferramentas de Banco de Dados do MongoDB**, um conjunto de ferramentas para tarefas administrativas, como dump/restore e import/export (dump/restauração e importação/exportação).

### 1.3 Interação dos Componentes
Você precisa de uma ferramenta para acessar uma instância do **mongod**. Você pode usar o shell do MongoDB ou uma ferramenta de terceiros.

O fluxo de interação é o seguinte:

**mongo → conecta-se a → mongod**

Como o **mongod** é o processo do banco de dados, você pode verificar seu status executando o seguinte comando:

`systemctl status mongod`

> [!IMPORTANT]
> Lembre-se de sempre ter criado DockerFile, pois sem o file não será instanciado uma imagem nova.

### 1.4 Topologia

Uma pergunta que você pode ter neste momento é:

> O que posso fazer com esses componentes?

O MongoDB oferece uma implementação diversificada para replicação e disponibilidade de dados, e esses são os componentes necessários para utilizar esses recursos.

As implementações possíveis incluem o seguinte:

**_Standalone_ (Instância Independente):** A instalação básica, um único nó mongod.

**_Replica set_ (Conjunto de Réplicas):** Replicação padrão, várias cópias dos dados em servidores de banco de dados diferentes, oferecendo um nível de tolerância a falhas contra a perda de um único servidor de banco de dados.

![](./resources/images/replica-set-read-write-operations-primary.png)

O _primário_ e os _secundários_ são processos `mongod` que rodam em diferentes locais. Você pode usar o shell do MongoDB (`mongo`) para interagir com eles.

> A configuração mínima recomendada para um conjunto de réplicas é de três membros — um primário e dois secundários.

**_Sharded cluster_ (Cluster Fragmentado):** Esse recurso de cluster do MongoDB permite distribuir dados em várias máquinas (escala horizontal), para conjuntos de dados muito grandes e operações de alto desempenho.

![](./resources/images/sharded-cluster-production-architecture.png)

Em vez de se conectar ao `mongod`, a aplicação deve se conectar a um roteador (`mongos`).

Para tarefas administrativas, você pode usar o shell do MongoDB para se conectar tanto ao `mongos` quanto ao `mongod`.

### 1.5 Construíndo a imagem docker do MongoDB 
1. Para construir a imagem, navegue para a pasta **impacta-labs/mongodb** e execute o seguinte comando:
```bash
docker docker build -t impacta_estudo_mongodb .
```

2. Para iniciar o container, execute o seguinte comando:
```bash
docker run -d -p 27017:27017 --name mongodb-standalone impacta_estudo_mongodb
```

#### Shell do MongoDB

Primeiro, vamos tentar conectar usando o shell do MongoDB (**mongosh**) sem nome de usuário e senha.

1. Para acessar o shell do MongoDB, execute o seguinte comando:   
```bash  
docker exec -it mongodb-standalone mongosh
```

2. Para navegar no banco de dados, execute o seguinte comando:
```bash
db
```

3. Para exibir as coleções do banco de dados, execute o seguinte comando:
```bash
show collections
```

4. Para sair do shell do MongoDB, execute o seguinte comando:
```
exit
```


> [!IMPORTANT]
> Antes de seguir em frente, é importante destacar que essa instância não tem controle de acesso habilitado, o que permite que você se conecte livremente sem nome de usuário e senha. Do ponto de vista da segurança, essa não é uma configuração recomendada para ambientes de produção.



Ótimo! Você usou o shell do MongoDB para se conectar a uma instância MongoDB.

Uma vez conectado, você pode navegar e exibir as estruturas do banco de dados.

### 1.6 Inserindo dados no MongoDB

1. Os dados para criação das Collections, está especificada no arquivo ```collection_purchase.json```, e ```collection_description_products.json```

>[!NOTE]
> Lembre-se de execultar a insert antes das consultas.

> É uma boa prática incluir um identificador único em cada documento quando ele é inserido.


### Perguntas a serem respondidas

1. Qual é a média de produtos comprados por cliente?

### Query 1

 ```javascript
db.purchase.aggregate([
    {
      $group: {
        _id: "$id_cliente",                       
        nome_cliente: { $first:"$nome_cliente"},
        media_preco: { $avg: "$produto.preco" }   
      }
    }
  ]);
  ```
### Retorno da Query

```javascript
[
    { _id: 3100, nome_cliente: 'Edwilson Jacinto', media_preco: 326.08 },
    { _id: 2, nome_cliente: 'Bianca o Carneiro', media_preco: 919.4625 },
    { _id: 1200, nome_cliente: 'Fernanda Ferreira Marques', media_preco: 145.575},
    { _id: 2000,nome_cliente: 'Sueli Resende', media_preco: 423.38571428571424},
    { _id: 3, nome_cliente: 'Nando Molina', media_preco: 310.31875 },
    { _id: 1, nome_cliente: 'Guilherme Masao', media_preco: 145.575 },
    { _id: 120, nome_cliente: 'Josué Marques', media_preco: 145.575 }
  ]

```

2. Quais são os 20 produtos mais populares por estado dos clientes?

### Query 2

```javascript
 db.purchase.aggregate([
    {
        $group: {
            _id: {
                estado: "$endereco.estado", 
                produto: "$produto.nome_produto"
            },
            total_vendas: { $sum: 1 }
        }
    },
    {
        $sort: { "total_vendas": -1 }
    },
    {
        $group: {
            _id: "$_id.estado",
            produtos: {
                $push: {
                    nome_produto: "$_id.produto",
                    total_vendas: "$total_vendas"
                }
            }
        }
    },
    {
        $project: {
            _id: 0,
            estado: "$_id",
            produtos: { $slice: ["$produtos", 20] }
        }
    }
])
```

### Retorno da Query

```javascript
[
  {
    estado: 'Sao Paulo',
    produtos: [
      { nome_produto: 'P.O.D', total_vendas: 2 },
      { nome_produto: 'Senhor dos Anéis', total_vendas: 2 },
      { nome_produto: 'Tábua de Madeira', total_vendas: 2 },
      { nome_produto: 'Roube como um Artista', total_vendas: 2 },
      { nome_produto: 'BDS', total_vendas: 2 },
      { nome_produto: 'Kate Perry', total_vendas: 2 },
      { nome_produto: 'Ralador Elétrico', total_vendas: 2 },
      { nome_produto: 'Air Fryer', total_vendas: 2 }
    ]
  },
  {
    estado: 'Rio de Janeiro',
    produtos: [
      { nome_produto: 'Five Finger Death Punch', total_vendas: 2 },
      { nome_produto: 'Cafeteira', total_vendas: 2 },
      { nome_produto: 'Senhor dos Anéis As Duas Torres', total_vendas: 2 },
      { nome_produto: 'Restart', total_vendas: 2 },
      { nome_produto: 'Scrum - Como fazer o Dobro do Trabalho na Metado do Tempo', total_vendas: 2 },
      { nome_produto: 'Churrasqueira Elétrica', total_vendas: 2 },
      { nome_produto: 'Fresno', total_vendas: 2 },
      { nome_produto: 'Geladeira', total_vendas: 1 }
    ]
  },
  {
    estado: 'Bahia',
    produtos: [
      { nome_produto: 'Five Finger Death Punch', total_vendas: 1 },
      { nome_produto: 'Engenheiros do Havaí', total_vendas: 1 },
      { nome_produto: 'Fogão', total_vendas: 1 },
      { nome_produto: 'Elba Ramalho', total_vendas: 1 },
      { nome_produto: 'Senhor dos Anéis - O Retorno do Rei', total_vendas: 1 },
      { nome_produto: 'Máquina de Chopp', total_vendas: 1 },
      { nome_produto: 'Data Science Para Negócios', total_vendas: 1 }
    ]
  },
  {
    estado: 'Curitiba',
    produtos: [
      { nome_produto: 'BDS', total_vendas: 1 },
      { nome_produto: 'P.O.D', total_vendas: 1 },
      { nome_produto: 'Roube como um Artista', total_vendas: 1 },
      { nome_produto: 'Tábua de Madeira', total_vendas: 1 },
      { nome_produto: 'Air Fryer', total_vendas: 1 },
      { nome_produto: 'Senhor dos Anéis', total_vendas: 1 },
      { nome_produto: 'Ralador Elétrico', total_vendas: 1 },
      { nome_produto: 'Kate Perry', total_vendas: 1 }
    ]
  },
  {
    estado: 'Acre',
    produtos: [
      { nome_produto: 'Data Science Para Negócios', total_vendas: 1 },
      { nome_produto: 'Elba Ramalho', total_vendas: 1 },
      { nome_produto: 'Fogão', total_vendas: 1 },
      { nome_produto: 'Engenheiros do Havaí', total_vendas: 1 },
      { nome_produto: 'Five Finger Death Punch', total_vendas: 1 },
      { nome_produto: 'Máquina de Chopp', total_vendas: 1 },
      { nome_produto: 'Batedeira', total_vendas: 1 },
      {nome_produto: 'Senhor dos Anéis - O Retorno do Rei', total_vendas: 1}
    ]
  }
]


```

3. Qual é o valor médio das vendas por estado do cliente?

### Query 3

```javascript

db.purchase.aggregate([
    {
        $group: {
          _id : "$endereco.estado",
          media_vendas: { $avg: "$produto.preco" }
        }
      }
  ]);

```

### Retorno Query 3

```javascript

[
    { _id: 'Acre', media_vendas: 310.31875 },
    { _id: 'Bahia', media_vendas: 326.08 },
    { _id: 'Curitiba', media_vendas: 145.575 },
    { _id: 'Rio de Janeiro', media_vendas: 687.9599999999999 },
    { _id: 'Sao Paulo', media_vendas: 145.575 }
  ]

```

4. Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?

### Query 4 

```javascript

db.purchase.aggregate([
    {
        $match: {
            dt_compra: { 
                $gte: new Date(new Date().setDate(new Date().getDate() - 30))
            }
        }
    },
    {
        $group: {
            _id: "$produto.categoria",
            total_vendas: { $sum: 1 }
        }
    },
    {
        $sort: { total_vendas: -1 } // Ordena pela quantidade de vendas em ordem decrescente
    }
]);

```

>[!Tip]
>
>Não funcionou rodando via Shell, caso tente rodar diretamente pela interface ou via node.
