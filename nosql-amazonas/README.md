# Caso de Estudo NoSQL - MBA Impacta

## Integrantes do Grupo
- Felipe Santos Silvino - RA 2502102

---

## Justificativas das Decisões

### 1. Modelagem de Dados: Múltiplas Coleções

Optei por uma abordagem de múltiplas coleções (`usuarios`, `produtos`, `pedidos`) pelos seguintes motivos:

- **Organização e Clareza:** Separação lógica das entidades de negócio, facilitando a manutenção e o entendimento do banco de dados.
- **Performance:** Consultas são executadas em coleções menores e mais específicas, resultando em maior rapidez.
- **Redução de Duplicidade de Dados:** Dados de usuários e produtos são armazenados uma única vez e referenciados nos pedidos, otimizando o armazenamento.
- **Escalabilidade:** O modelo permite a fácil adição de novas entidades (como `fornecedores`) no futuro, conforme a empresa cresce, sem impactar as coleções existentes.

### 2. Schema e Escolha de Campos

A estrutura de cada coleção foi pensada para responder às perguntas de negócio de forma eficiente. Destaques:

- **`pedidos.itens` como um Array de Objetos:** Permite modelar a relação "um-para-muitos" entre um pedido e seus produtos de forma natural, uma das grandes vantagens do NoSQL.
- **Denormalização Estratégica:** Incluímos campos como `nome_produto` e `categoria_produto` dentro do array `itens` na coleção `pedidos`. Isso evita a necessidade de múltiplas consultas (`$lookups`) para obter informações básicas de um pedido, otimizando a performance de leitura.
- **Tipos de Dados:** Utilizamos tipos específicos como `Date` e `NumberDecimal` para garantir a precisão em consultas temporais e cálculos financeiros.

### 3. A pergunta escolhida para ser respondida foi:
Pergunta 4 - Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?

**Resultado**
Felipe Silvino@FATODESK-001 MINGW64 ~/iCloudDrive/_Projetos Pessoais/MBA Impacta/LABS/Nosql-databases/impacta-labs/nosql-databases/mongodb/nosql-amazonas (main)
$ ./command_mongo.sh
Executando agregação no banco de dados 'amazonasDB' dentro do container 'mongodb-standalone'...
[
  { total_vendido: 3, categoria: 'CDs' },
  { total_vendido: 3, categoria: 'Eletrodomésticos de Cozinha' },
  { total_vendido: 4, categoria: 'Eletrônicos' },
  { total_vendido: 4, categoria: 'Livros' }
]

### 4. Instruções de Uso:
Como estou utilizando o mongo em uma imagem no Docker, primeiro iremos copiar os jsons para /tmp do docker
para importar as collections no mongo.

1 - Copia os jsons para o /tmp do Docker
```bash
docker cp .\nosql-amazonas\collection_usuarios.json mongodb-standalone:/tmp/
docker cp .\nosql-amazonas\collection_produtos.json mongodb-standalone:/tmp/
docker cp .\nosql-amazonas\collection_pedidos.json mongodb-standalone:/tmp/
```

2 - Importando as collections "usuarios", "produtos" e "pedidos"
```bash
docker exec mongodb-standalone mongoimport --db amazonasDB --collection usuarios --file /tmp/collection_usuarios.json --jsonArray
docker exec mongodb-standalone mongoimport --db amazonasDB --collection produtos --file /tmp/collection_produtos.json --jsonArray
docker exec mongodb-standalone mongoimport --db amazonasDB --collection pedidos --file /tmp/collection_pedidos.json --jsonArray
```

3 - Executando o shellscript "Obs: Rodei no Git Bash"
```bash
./command_mongo.sh
```