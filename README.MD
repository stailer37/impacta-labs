# Grupo 1 
Integrantes: 

- Jorge Rodrigues de Moraes Junior  RA: 2500751
- Ellen Cristina Tavares Gabriel    RA: 1520194
- Daniel Silva Ramos                RA: 2502443
- Rodrigo Zapiello                  RA: 2501928
- Mélany Santos Antoniazzi          RA: 2102353


# Escolha da pergunta 

Optamos por responder : 
Quais são os 20 produtos mais populares por estado dos clientes?


# Melhor abordagem:
Optamos pela coleção única com documentos que representem as compras dos usuários (eventos de compra), contendo informações:

do cliente (com estado)
do produto (tipo, nome, categoria etc.)
da compra (data, quantidade)

- Assim, conseguimos fazer queries agregadas facilmente, como "top produtos por estado" de forma escalavel.

Exemplo de documento : 
```json
  {
    _id: ObjectId('68a655db368bfe9dd753e9c1'),
    cliente_id: 'c241330b-01a9-471f-9e8a-774bcf36d58b',
    estado: 'PE',
    produto: {
      produto_id: 'livro-002',
      nome: 'A Revolução dos Bichos',
      categoria: 'livro'
    },
    quantidade: 3,
    data_compra: '2025-04-07T19:48:37.225751'
  },
```

Siga os passos abaixo para simular a query : 



### 1.5 Construíndo a imagem docker do MongoDB 
1. Para construir a imagem, navegue para a pasta **impacta-labs/nosql-databases/mongodb** e execute o seguinte comando:
```bash
docker build -t impacta_labs_mongodb .
```

2. Para iniciar o container, execute o seguinte comando:
```bash
docker run -d -p 27017:27017 --name mongodb-standalone impacta_labs_mongodb
```


### Importando os Documentos para docker 


- Copie o arquivo para o docker 
**dentro da pasta impacta-labs/**
```bash 
docker cp compras.json mongodb-standalone:/compras.json
```

- Importe o arquivo 
```bash
docker exec -it mongodb-standalone mongoimport --db test --collection compras --file /compras.json --type json --legacy
```

- Acesse o mongosh e excute a query do arquivo command_mongo.sh

Para acessar o shell do MongoDB, execute o seguinte comando:   
```bash  
docker exec -it mongodb-standalone mongosh
```

Execute a query  do arquivo commmand_mongo.sh

