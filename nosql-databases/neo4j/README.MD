## 1. Fundamentos do Neo4j

### 1.1 Introdução ao Neo4j

O Neo4j é um banco de dados orientado a grafos que permite armazenar e consultar dados de forma eficiente, utilizando uma estrutura de grafos. Ele é especialmente útil para representar relacionamentos complexos entre dados.

Ao longo deste laboratório, você aprenderá a criar um banco de dados de grafos, inserir dados e realizar consultas utilizando a linguagem Cypher.

### 1.2 Construíndo a imagem docker do Neo4j
1. Para construir a imagem, navegue para a pasta **impacta-labs/nosql-databases/neo4j** e execute o seguinte comando:
```bash
docker build -t impacta_labs_neo4j .
```

2. Para iniciar o container, execute o seguinte comando:
```bash
docker run -d --name neo4j-node -p 7474:7474 -p 7687:7687 impacta_labs_neo4j
```
> [!WARNING]
> O container pode demorar alguns minutos para iniciar. Você pode acompanhar o progresso usando o comando `docker logs neo4j-node`.

O container do Neo4j irá publicar uma interface web na porta 7474. Essa interface pode ser acessada em http://localhost:7474.

Neste laboratório iremos utilizar interface web, o Neo4j Browser que é um cliente orientado por comandos em um ambiente de shell baseado na web, para interagir com o Neo4j.

> [!NOTE]
> Caso seja necessário, utilize o login com o usuário `neo4j` e senha `impacta@labs`.

### 1.3 Importando dados para o Neo4j
Uma vez logado com sucesso, você deverá ter acesso a uma interface similar a imagem a seguir:

![Neo4j Browser](./resources/images/neo4j-browser.png)

1. No menu superior temos um console que inicia com `neo4j$` que permite executar comandos Cypher, vamos executar os comandos a seguir para popular os dados necessários para este laboratório.

2. Copie e cole o conteúdo do arquivo `actor_movies.gql` que está na pasta `resources/scripts` no console do Neo4j Browser e execute o comando.

Link do arquivo: [actor_movies.gql](./resources/scripts/actor_movies.gql)

Agora vamos entender o que cada comando acima faz:

```sql
CREATE (TheMatrix:Movie {title:'The Matrix', released:1999, tagline:'Welcome to the Real World'})
````

O comando acima cria uma entidade `TheMatrix` do tipo `Movie` com os atributo `title`,  `released` e `tagline` com seus respectivos valores associados.

```sql
CREATE (Keanu:Person {name:'Keanu Reeves', born:1964})
````

O comando acima cria uma entidade `Keanu` do tipo `Person` com os atributos `name` e `born` e seus respectivos valores associados.

```sql
(Keanu)-[:ACTED_IN {roles:['Neo']}]->(TheMatrix)
```

O comando acima cria uma relação `ACTED_IN` entre a entidade do tipo pessoa `Keanu` e a entidade do tipo filme `TheMatrix` com os atributos `roles` e seus respectivos valores associados.

Além da relação `ACTED_IN` temos outras como `DIRECTED`, `PRODUCED` e `WROTE`.

```sql
CREATE
(JamesThompson)-[:FOLLOWS]->(JessicaThompson)
```

O comando acima cria uma relação `FOLLOWS` entre duas entidades do tipo pessoa, `JamesThompson` e `JessicaThompson`.

```sql
CREATE
(JessicaThompson)-[:REVIEWED {summary:'An amazing journey', rating:95}]->(CloudAtlas)
```

O comando acima cria uma relação `REVIEWED` entre duas entidades, `JessicaThompson` do tipo pessoa e `CloudAtlas` do tipo filme com os atributos `summary` e `rating` e seus respectivos valores associados.

### 1.4 Consultando o Neo4j

Vamos imaginar um cenário em que queremos encontrar o ator de nome "Tom Hanks", para isso vamos utilizar o comando `MATCH`:
```sql
MATCH (a:Person {name:'Tom Hanks'}) RETURN a
```

O mesmo poderia ser feito para um filme:
```sql
MATCH (m:Movie {title:'The Matrix'}) RETURN m
```

Nos dois exemplos acima, usamos variáveis para identificar os tipos de entidade e seus atributos. A variável `a` representa a entidade do tipo pessoa e `m` representa a entidade do tipo filme. E utilizamos o comando `RETURN` para retornar as entidades encontradas.

Podemos fazer consulas mais genéricas como retornar o atributo nome de algumas pessoas:
```sql
MATCH (people:Person) RETURN people.name LIMIT 10
```

Ou mesmo buscar filmes que foram lançados entre os anos 90:
```sql
MATCH (nineties:Movie) WHERE nineties.released >= 1990 AND nineties.released < 2000 RETURN nineties.title, nineties.released
```

Agora vamos imaginar em um banco de dados relacional, se quisessemos saber todos os filmes nos quais o ator Tom Hanks atuou, precisariamos realizar uma operação de `JOIN` entre as tabelas `Person` e `Movie`, uma consulta exemplo como a seguinte:
```sql
SELECT
  m.title
FROM
  person p
INNER JOIN
  movie m ON p.id = m.person_id
WHERE
  p.name = 'Tom Hanks'
``` 

Utilizando o Cypher, podemos fazer a mesma coisa da seguinte forma:
```sql
MATCH (a:Person {name:'Tom Hanks'})-[:ACTED_IN]->(m:Movie) RETURN m.title
```

Poderiamos ir além e localizar quais foram os atores que atuaram em conjunto com o ator Tom Hanks:
```sql
MATCH (a:Person {name:"Tom Hanks"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActors) RETURN coActors.name
```

Se quisessemos contar em quantos filmes o ator Tom Hanks atuou, poderiamos fazer:
```sql
MATCH (a:Person {name:'Tom Hanks'})-[:ACTED_IN]->(m:Movie) RETURN count(a)
```

### 1.5 Percorrendo grafos

Relembrando das propriedades de um grafo, temos o grau e a proximidade entre arestas e vertices, no caso de pessoas e filmes, poderiamos buscar a quantos pulos estamos de distância do ator Tom Hanks até a atriz Meg Ryan:
```sql
MATCH p=shortestPath(
(a:Person {name:"Tom Hanks"})-[*]-(b:Person {name:"Meg Ryan"})
)
RETURN p
```

Neste caso, temos uma ligação direta pois ambos estavam em um mesmo filme.

Vamos observar outro exemplo agora utilizando o ator Kevin Bacon e a atriz Meg Ryan:
```sql
MATCH p=shortestPath(
(bacon:Person {name:"Kevin Bacon"})-[*]-(meg:Person {name:"Meg Ryan"})
)
RETURN p
```

Neste caso o ator Kevin Bacon estaria a um "pulo" de distância da Meg Ryan, pois não atuaram ativamente em um filme juntos. Contudo, existe o ator Tom Cruise que atua como elementos de ligação entre os dois.

### 1.6 Recomendações em grafos
Vamos recomendar novos co-atores para Tom Hanks. Uma abordagem básica de recomendação é encontrar conexões além de sua vizinhança imediata, que sejam, por sua vez, bem conectadas.

Para Tom Hanks, isso significa:

- Encontrar atores com quem Tom Hanks ainda não trabalhou, mas com quem seus co-atores já trabalharam.
- Encontrar alguém que possa apresentar Tom ao seu potencial co-ator.

```sql
MATCH (tom:Person {name:"Tom Hanks"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActors),
  (coActors)-[:ACTED_IN]->(m2)<-[:ACTED_IN]-(cocoActors)
WHERE NOT (tom)-[:ACTED_IN]->()<-[:ACTED_IN]-(cocoActors) AND tom <> cocoActors
RETURN cocoActors.name AS Recommended, count(*) AS Strength ORDER BY Strength DESC
```

Explicando em detalhes o comando acima, podemos ver que:

- O comando `MATCH` busca atores com quem Tom Hanks ainda não trabalhou, mas com quem seus co-atores já trabalharam.
- O comando `WHERE` filtra os atores que ainda não trabalharam com Tom Hanks e que seus co-atores trabalharam com ele.
- O comando `RETURN` retorna os nomes dos atores recomendados e a quantidade de conexões que eles possuem com Tom Hanks.

Como resultado, temos a recomendação de Tom Cruise e Zach Grenier, ambos com alto potencial de atuarem com Tom Hanks.

Precisamos por fim, encontrar uma forma de introduzir Tom Hanks a Tom Cruise e Zach Grenier. Qual é o elemento de ligação entre eles:
```sql
MATCH (tom:Person {name:"Tom Hanks"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActors),
  (coActors)-[:ACTED_IN]->(m2)<-[:ACTED_IN]-(cruise:Person {name:"Tom Cruise"})
RETURN DISTINCT coActors.name
````

### Deletando dados no Neo4j
Para deletar todos os Filmes e Pessoas, bem como suas relações, podemos utilizar o seguinte comando:
```sql
MATCH (n) DETACH DELETE n
```

O comando `DETACH` remove as relações e o comando `DELETE` remove as entidades.

## 2. Agora é a sua vez!
Exercícios para praticar o que aprendeu. Utilize o dataset de filmes e pessoas para responder as seguintes perguntas:
1. Quais são os 5 atores que mais atuaram em filmes?
- Dica: utilize o `match` e o `count` para contar as relações de atuação.
2. Quais são os 5 diretores que mais dirigiram filmes?
- Dica: utilize o `match` e o `count` para contar as relações de direção.
3. Quais as melhores avaliações (rating) em filmes?
- Dica: utilize o `match` e o `order by` para ordenar as avaliações.
4. Quais atores nunca atuaram juntos?
- Dica: utilize o `match` e o `where` para filtrar os atores.

## 3. Recursos Adicionais para Estudo
### 3.1. Documentação Oficial
- [Documentação Oficial do Neo4j](https://neo4j.com/docs/): Documentação completa do Neo4j.
- [Cypher Query Language](https://neo4j.com/docs/cypher-manual/current/): Guia completo da linguagem de consulta Cypher.
- [Neo4j Graph Data Science](https://neo4j.com/docs/graph-data-science/current/): Bibliotecas para análise de grafos e machine learning.

### 3.2. Ferramentas Recomendadas
- [Neo4j Desktop](https://neo4j.com/download/): Ambiente de desenvolvimento integrado para trabalhar com Neo4j localmente.
- [APOC Library](https://neo4j.com/labs/apoc/): Biblioteca de procedimentos e funções úteis para Neo4j.

### 3.3. Livros Recomendados
- [Graph Databases: New Opportunities for Connected Data](https://a.co/d/aTsJ8hN) por Ian Robinson, Jim Webber e Emil Eifrem.
- [Neo4j: The Definitive Guide: Hands-On Recipes for Production-Ready Graph Implementations](https://a.co/d/g6uSnbo) por Luanne Misquitta, Christophe Willemsen 