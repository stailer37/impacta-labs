
#Criação da collection vendas com os campos nome_cliente,loja, produto, quantidade, data_venda, valor_venda
db.vendas.insertMany(
   [
    {
        "nome_cliente": "Larissa Campos",
        "loja": "Loja C",
        "produto": "Máquina de Lavar",
        "quantidade": 4,
        "data_venda": "2024-05-05",
        "valor_venda": 9890.72
    },
    {
        "nome_cliente": "Vitor Hugo Moraes",
        "loja": "Loja A",
        "produto": "Cafeteira",
        "quantidade": 2,
        "data_venda": "2023-08-21",
        "valor_venda": 2538.66
    },
    {
        "nome_cliente": "Giovanna Castro",
        "loja": "Loja C",
        "produto": "Liquidificador",
        "quantidade": 4,
        "data_venda": "2024-05-15",
        "valor_venda": 18885.16
    },
    {
        "nome_cliente": "Dr. Pedro Farias",
        "loja": "Loja C",
        "produto": "Rádio",
        "quantidade": 5,
        "data_venda": "2024-10-13",
        "valor_venda": 16246.45
    },
    {
        "nome_cliente": "Dr. João Guilherme Pires",
        "loja": "Loja A",
        "produto": "Fogão",
        "quantidade": 4,
        "data_venda": "2023-04-24",
        "valor_venda": 4860.12
    },
    {
        "nome_cliente": "Samuel Porto",
        "loja": "Loja C",
        "produto": "Máquina de Lavar",
        "quantidade": 5,
        "data_venda": "2022-12-12",
        "valor_venda": 8413.1
    },
    {
        "nome_cliente": "Nina Dias",
        "loja": "Loja B",
        "produto": "Cafeteira",
        "quantidade": 4,
        "data_venda": "2024-07-03",
        "valor_venda": 10767.6
    },
    {
        "nome_cliente": "Nicole Castro",
        "loja": "Loja C",
        "produto": "Liquidificador",
        "quantidade": 1,
        "data_venda": "2024-01-22",
        "valor_venda": 3677.87
    },
    {
        "nome_cliente": "Dr. Enrico Ramos",
        "loja": "Loja C",
        "produto": "Rádio",
        "quantidade": 5,
        "data_venda": "2023-06-23",
        "valor_venda": 6257.3
    },
    {
        "nome_cliente": "Luiz Henrique da Costa",
        "loja": "Loja D",
        "produto": "Fogão",
        "quantidade": 4,
        "data_venda": "2023-04-13",
        "valor_venda": 13651.84
    },
    {
        "nome_cliente": "Alícia Cardoso",
        "loja": "Loja C",
        "produto": "Geladeira",
        "quantidade": 1,
        "data_venda": "2023-03-23",
        "valor_venda": 1995.86
    },
    {
        "nome_cliente": "Isabella da Mata",
        "loja": "Loja C",
        "produto": "Televisão",
        "quantidade": 1,
        "data_venda": "2023-09-26",
        "valor_venda": 2205.92
    },
    {
        "nome_cliente": "Lorenzo Ferreira",
        "loja": "Loja D",
        "produto": "Rádio",
        "quantidade": 3,
        "data_venda": "2023-12-29",
        "valor_venda": 9226.11
    },
    {
        "nome_cliente": "Sra. Gabriela Pires",
        "loja": "Loja B",
        "produto": "Fogão",
        "quantidade": 1,
        "data_venda": "2023-07-07",
        "valor_venda": 3362.79
    },
    {
        "nome_cliente": "Sr. Isaac Azevedo",
        "loja": "Loja B",
        "produto": "Microondas",
        "quantidade": 2,
        "data_venda": "2022-12-23",
        "valor_venda": 910.22
    },
    {
        "nome_cliente": "Enzo Pires",
        "loja": "Loja B",
        "produto": "Secadora",
        "quantidade": 4,
        "data_venda": "2023-10-01",
        "valor_venda": 7238.52
    },
    {
        "nome_cliente": "Paulo Fernandes",
        "loja": "Loja C",
        "produto": "Rádio",
        "quantidade": 2,
        "data_venda": "2023-05-04",
        "valor_venda": 4214.14
    },
    {
        "nome_cliente": "João Gabriel Gomes",
        "loja": "Loja A",
        "produto": "Liquidificador",
        "quantidade": 1,
        "data_venda": "2024-06-22",
        "valor_venda": 3812.59
    },
    {
        "nome_cliente": "Otávio Dias",
        "loja": "Loja D",
        "produto": "Máquina de Lavar",
        "quantidade": 2,
        "data_venda": "2023-06-01",
        "valor_venda": 8146.38
    },
    {
        "nome_cliente": "Nathan Barbosa",
        "loja": "Loja C",
        "produto": "Cafeteira",
        "quantidade": 1,
        "data_venda": "2023-07-03",
        "valor_venda": 1617.83
    },
    {
        "nome_cliente": "Bárbara Melo",
        "loja": "Loja B",
        "produto": "Máquina de Lavar",
        "quantidade": 4,
        "data_venda": "2023-06-19",
        "valor_venda": 8378.44
    },
    {
        "nome_cliente": "Luiz Gustavo Azevedo",
        "loja": "Loja D",
        "produto": "Rádio",
        "quantidade": 2,
        "data_venda": "2023-04-14",
        "valor_venda": 3492.48
    },
    {
        "nome_cliente": "João Correia",
        "loja": "Loja D",
        "produto": "Cafeteira",
        "quantidade": 3,
        "data_venda": "2023-05-11",
        "valor_venda": 13263.33
    },
    {
        "nome_cliente": "Isadora Teixeira",
        "loja": "Loja A",
        "produto": "Máquina de Lavar",
        "quantidade": 1,
        "data_venda": "2023-09-14",
        "valor_venda": 3824.4
    },
    {
        "nome_cliente": "Julia Santos",
        "loja": "Loja D",
        "produto": "Televisão",
        "quantidade": 2,
        "data_venda": "2023-02-21",
        "valor_venda": 8718.14
    },
    {
        "nome_cliente": "Dra. Bárbara Mendes",
        "loja": "Loja B",
        "produto": "Aspirador de Pó",
        "quantidade": 3,
        "data_venda": "2024-07-13",
        "valor_venda": 8718.3
    },
    {
        "nome_cliente": "João Lucas das Neves",
        "loja": "Loja B",
        "produto": "Secadora",
        "quantidade": 1,
        "data_venda": "2023-09-19",
        "valor_venda": 3758.93
    },
    {
        "nome_cliente": "Maria Eduarda Viana",
        "loja": "Loja B",
        "produto": "Máquina de Lavar",
        "quantidade": 1,
        "data_venda": "2023-05-16",
        "valor_venda": 1969.07
    },
    {
        "nome_cliente": "Sr. Carlos Eduardo Mendes",
        "loja": "Loja A",
        "produto": "Fogão",
        "quantidade": 5,
        "data_venda": "2024-01-23",
        "valor_venda": 1627.8
    },
    {
        "nome_cliente": "Fernanda Cardoso",
        "loja": "Loja A",
        "produto": "Máquina de Lavar",
        "quantidade": 1,
        "data_venda": "2024-09-05",
        "valor_venda": 4789.02
    },
    {
        "nome_cliente": "Dr. Arthur Lopes",
        "loja": "Loja C",
        "produto": "Microondas",
        "quantidade": 5,
        "data_venda": "2023-04-14",
        "valor_venda": 6085.3
    },
    {
        "nome_cliente": "Anthony Duarte",
        "loja": "Loja A",
        "produto": "Televisão",
        "quantidade": 4,
        "data_venda": "2024-05-16",
        "valor_venda": 7524.52
    },
    {
        "nome_cliente": "Breno Martins",
        "loja": "Loja A",
        "produto": "Secadora",
        "quantidade": 3,
        "data_venda": "2024-03-03",
        "valor_venda": 6971.94
    },
    {
        "nome_cliente": "Emanuella da Luz",
        "loja": "Loja A",
        "produto": "Aspirador de Pó",
        "quantidade": 1,
        "data_venda": "2024-09-30",
        "valor_venda": 3518.36
    },
    {
        "nome_cliente": "Beatriz Costa",
        "loja": "Loja B",
        "produto": "Geladeira",
        "quantidade": 2,
        "data_venda": "2023-04-16",
        "valor_venda": 5738.4
    },
    {
        "nome_cliente": "Nina Pires",
        "loja": "Loja C",
        "produto": "Fogão",
        "quantidade": 1,
        "data_venda": "2024-04-16",
        "valor_venda": 1467.46
    },
    {
        "nome_cliente": "Vitor Nascimento",
        "loja": "Loja B",
        "produto": "Secadora",
        "quantidade": 1,
        "data_venda": "2024-11-11",
        "valor_venda": 728.99
    },
    {
        "nome_cliente": "João Guilherme Araújo",
        "loja": "Loja D",
        "produto": "Liquidificador",
        "quantidade": 2,
        "data_venda": "2024-07-04",
        "valor_venda": 8363.36
    },
    {
        "nome_cliente": "Laura Lopes",
        "loja": "Loja C",
        "produto": "Fogão",
        "quantidade": 3,
        "data_venda": "2023-12-09",
        "valor_venda": 7647.78
    },
    {
        "nome_cliente": "Arthur Silveira",
        "loja": "Loja D",
        "produto": "Microondas",
        "quantidade": 1,
        "data_venda": "2023-03-18",
        "valor_venda": 2658.94
    },
    {
        "nome_cliente": "Breno da Rocha",
        "loja": "Loja A",
        "produto": "Máquina de Lavar",
        "quantidade": 3,
        "data_venda": "2024-08-10",
        "valor_venda": 4376.43
    },
    {
        "nome_cliente": "Dr. Ryan Monteiro",
        "loja": "Loja C",
        "produto": "Cafeteira",
        "quantidade": 4,
        "data_venda": "2024-04-24",
        "valor_venda": 16067.88
    },
    {
        "nome_cliente": "Arthur Farias",
        "loja": "Loja D",
        "produto": "Aspirador de Pó",
        "quantidade": 5,
        "data_venda": "2024-10-10",
        "valor_venda": 4295.8
    },
    {
        "nome_cliente": "Lara Barros",
        "loja": "Loja C",
        "produto": "Fogão",
        "quantidade": 3,
        "data_venda": "2023-09-11",
        "valor_venda": 12457.98
    },
    {
        "nome_cliente": "Erick Pires",
        "loja": "Loja D",
        "produto": "Liquidificador",
        "quantidade": 4,
        "data_venda": "2023-11-21",
        "valor_venda": 3365.68
    },
    {
        "nome_cliente": "João Vitor da Luz",
        "loja": "Loja D",
        "produto": "Cafeteira",
        "quantidade": 1,
        "data_venda": "2024-10-01",
        "valor_venda": 4670.2
    },
    {
        "nome_cliente": "Lorena da Luz",
        "loja": "Loja C",
        "produto": "Microondas",
        "quantidade": 3,
        "data_venda": "2023-02-12",
        "valor_venda": 8578.32
    },
    {
        "nome_cliente": "Matheus Rodrigues",
        "loja": "Loja D",
        "produto": "Geladeira",
        "quantidade": 4,
        "data_venda": "2024-05-17",
        "valor_venda": 10717.84
    },
    {
        "nome_cliente": "Maria Rezende",
        "loja": "Loja C",
        "produto": "Rádio",
        "quantidade": 3,
        "data_venda": "2024-06-13",
        "valor_venda": 1253.55
    },
    {
        "nome_cliente": "Maria Sophia Dias",
        "loja": "Loja C",
        "produto": "Cafeteira",
        "quantidade": 2,
        "data_venda": "2022-12-27",
        "valor_venda": 8243.28
    }

])


#Query para responder a primeira pergunta
#Qual é a média de produtos comprados por cliente?
#Resposta: 2.68
db.vendas.aggregate([
    {
        $group: {
            _id: "$nome_cliente",
            totalProdutos: { $sum: "$quantidade" }
        }
    },
    {
        $group: {
            _id: null, 
            mediaProdutos: { $avg: "$totalProdutos" } 
        }
    },
    {
        $project: {
            _id: 0,
            mediaProdutos: 1
        }
    }
]);
