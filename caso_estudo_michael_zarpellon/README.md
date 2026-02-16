# Projeto - Amazonas
- Nome: Michael Zarpellon - RA: 2500079

## Comandos executados no Terminal WSL
```
docker run -d -p 27017:27017 --name mongodb-standalone impacta_labs_mongodb
```

```
docker cp customers.json mongodb-standalone:/customers.json
docker cp products.json mongodb-standalone:/products.json
docker cp orders.json mongodb-standalone:/orders.json
docker cp click_events.json mongodb-standalone:/click_events.json
docker cp command_mongo.sh mongodb-standalone:/command_mongo.sh
```

``` 
docker exec -it mongodb-standalone bash -c "cd / && bash"
```

```
chmod +x /command_mongo.sh
./command_mongo.sh
```

## Questões Propostas + Saída Esperada
1. Qual é a média de produtos comprados por cliente?
```
[ { _id: null, media_produtos_por_cliente: 3.6666666666666665 } ]
```

2. Quais são os 20 produtos mais populares por estado dos clientes?
```
[
  { _id: { estado: 'RJ', produto: 'P002' }, total_vendido: 5 },
  { _id: { estado: 'SP', produto: 'P001' }, total_vendido: 3 },
  { _id: { estado: 'MG', produto: 'P003' }, total_vendido: 2 },
  { _id: { estado: 'RJ', produto: 'P001' }, total_vendido: 1 }
]
```

3. Qual é o valor médio das vendas por estado do cliente?
```
[
  { _id: 'RJ', valor_medio_vendas: 5149.7 },
  { _id: 'MG', valor_medio_vendas: 999.8 },
  { _id: 'SP', valor_medio_vendas: 899.7 }
]
```
4. Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?
```
[
  { _id: 'eletronico', total_vendido: 7 },
  { _id: 'eletrodomestico', total_vendido: 4 }
]
```

### Motivações
Optei por escolher múltiplas collections para garantir:
- Separação clara de responsabilidades, evitando documentos gigantes e buscar uma melhor escalabilidade
- Não obstante, temos que `orders` e `click_events` tendem a ser volumosas por serem transacionais.
- Enquanto que `products` e `customers` são cadastrais.

### Operadores Utilizados
- aggregate: Usado para agrupar os itens por categoria.
- $match: Utilizado para filtrar documentos com base em determinados critérios.
- $gte: Condição "maior ou igual".
- $group: Utilizado para agrupar documentos por algum campo específico e realizar operações agregadas.
- $project: Utilizado para especificar quais campos devem ser incluídos ou excluídos no resultado da agregação, permitindo reformular os documentos.

