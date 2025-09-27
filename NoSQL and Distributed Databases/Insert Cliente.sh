db.clientes.insertMany([
  {
    "_id": clienteId1,
    "nome": "Ana Clara Souza",
    "email": "ana.souza@email.com",
    "endereco": { "rua": "Av. Paulista, 1500", "cidade": "São Paulo", "estado": "SP", "cep": "01310-200" },
    "data_registro": new Date("2024-01-15T10:00:00Z")
  },
  {
    "_id": clienteId2,
    "nome": "Bruno Costa",
    "email": "bruno.costa@email.com",
    "endereco": { "rua": "Rua da Passagem, 90", "cidade": "Rio de Janeiro", "estado": "RJ", "cep": "22290-030" },
    "data_registro": new Date("2024-03-22T11:30:00Z")
  },
  {
    "_id": clienteId3,
    "nome": "Carla Martins",
    "email": "carla.martins@email.com",
    "endereco": { "rua": "Av. Afonso Pena, 4000", "cidade": "Belo Horizonte", "estado": "MG", "cep": "30130-009" },
    "data_registro": new Date("2024-05-30T18:00:00Z")
  },
  {
    "_id": clienteId4,
    "nome": "Daniel Almeida",
    "email": "daniel.almeida@email.com",
    "endereco": { "rua": "Av. Sete de Setembro, 250", "cidade": "Salvador", "estado": "BA", "cep": "40060-001" },
    "data_registro": new Date("2024-07-01T09:00:00Z")
  },
  {
    "_id": clienteId5,
    "nome": "Elisa Ferreira",
    "email": "elisa.ferreira@email.com",
    "endereco": { "rua": "Rua dos Andradas, 1000", "cidade": "Porto Alegre", "estado": "RS", "cep": "90020-007" },
    "data_registro": new Date("2024-08-19T14:45:00Z")
  }
]);
print("5 clientes inseridos.");