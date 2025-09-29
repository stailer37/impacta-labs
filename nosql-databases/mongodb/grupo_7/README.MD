# Grupo 7 - NoSQL
Nomes:
Fernanda Cristina Gomes Nori - 2501681
Hedir Saraiva de Albuquerque - 
Felipe Santos Araujo - 
Felipe Ensinas Alves - 2500260
Felipe Santos Silvino - 2502102
Caio Afonso Felipe Da Silva - 2500389
Danilo Pazianotto Oliveira - 2500466
Lucas Washimi Thinen - 
Isabelle tais da Silva Nunes - 2501861

## Escolha de coleção múltipla ou simples.
Para este trabalho escolhemos a coleção múltipla pois ela é mais robusta e eficiente pensando em um banco de dados gigante, acreditamos que ela é mais escalável ao longo do tempo, Por este motivo temos dois arquivos JSON, são eles "collection_clientes.json" e "collection_compras.json".

## A pergunta escolhida para ser respondida nesse trabalho é:
    Qual a média de produtos comprados por cliente?

## Instruções de uso. 

Precisamos primeiramente importar o mongoimport para carregar os dados dos arquivos JSON.
Obs.: Utilizamos o WSL Ubuntu.

1 - Importando a coleção "Clientes"
```bash
mongoimport --db amazonas_ecommerce --collection clientes --file collection_clientes.json --jsonArray
```

2 - Importando a coleção "Compras"
```bash
mongoimport --db amazonas_ecommerce --collection compras --file collection_compras.json --jsonArray
```

3 - Execute o comando.
```bash
./command.mongo.sh
```
O resultado apareceu para nós como:
[
  {
    "media_produtos_por_cliente": 2.2
  }
]