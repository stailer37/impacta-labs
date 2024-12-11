# Qual é a média de produtos comprados por cliente?

db.compras.aggregate([
  { $group: { _id: "$cliente.id_cliente", total_compras: { $sum: 1 } } },
  { $group: { _id: null, media_compras: { $avg: "$total_compras" } } }
]);

# Quais são os 20 produtos mais populares por estado?

db.compras.aggregate([
  { $group: { _id: { estado: "$estado", produto: "$produto.nome" }, total_vendas: { $sum: 1 } } },
  { $sort: { "_id.estado": 1, total_vendas: -1 } },
  { $group: { _id: "$_id.estado", produtos: { $push: { nome: "$_id.produto", vendas: "$total_vendas" } } } },
  { $project: { estado: "$_id", produtos: { $slice: ["$produtos", 20] } } }
]);

# Qual é o valor médio das vendas por estado do cliente?

db.compras.aggregate([
  { $group: { _id: "$estado", valor_medio: { $avg: "$produto.valor" } } }
]);

# Quantos de cada tipo de produto foram vendidos nos últimos 30 dias?

db.compras.aggregate([
  { $match: { data_compra: { $gte: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000) } } },
  { $group: { _id: "$produto.categoria", total_vendas: { $sum: 1 } } }
]);

# Comando para popular o banco de dados
const categorias = ["livros", "cds", "eletro_cozinha"];
const estados = ["AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO"];
const produtos = {
  livros: ["O Senhor dos Anéis", "Harry Potter", "Dom Quixote", "Moby Dick", "A Divina Comédia", "Hamlet", "1984", "Orgulho e Preconceito", "A Metamorfose", "O Processo"],
  cds: ["Album Thriller", "Album Back in Black", "Album Dark Side of the Moon", "Album The Wall", "Album Led Zeppelin IV", "Album Abbey Road", "Album Sgt. Pepper's", "Album A Night at the Opera", "Album Born in the U.S.A.", "Album Appetite for Destruction"],
  eletro_cozinha: ["Liquidificador", "Batedeira", "Panela de Pressão", "Fritadeira Elétrica", "Cafeteira", "Mixer", "Sanduicheira", "Forno Elétrico", "Aspirador de Pó", "Fogão"]
};

const randomElement = arr => arr[Math.floor(Math.random() * arr.length)];
const randomPrice = () => (Math.random() * (500 - 30) + 30).toFixed(2);

const registros = [];

for (let i = 0; i < 30; i++) {
  const categoria = randomElement(categorias);
  const produto = randomElement(produtos[categoria]);
  const estado = randomElement(estados);
  const valor = parseFloat(randomPrice());
  const cliente = 'C${String(3 + i).padStart(3, "0")}';
  const dataCompra = new Date(Date.now() - Math.random() * 30 * 24 * 60 * 60 * 1000);
  
  registros.push({
    cliente: { primeiro_nome: 'Cliente${i + 4}', id_cliente: cliente },
    produto: { categoria: categoria, nome: produto, valor: valor },
    estado: estado,
    data_compra: dataCompra,
    quantidade: Math.floor(Math.random() * 3) + 1,
    click_stream: [
      { pagina: "home", timestamp: new Date(dataCompra - 15 * 60 * 1000) },
      { pagina: "produto", timestamp: new Date(dataCompra - 5 * 60 * 1000) }
    ]
  });
}