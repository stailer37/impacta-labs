import os
import json
import random
from datetime import datetime, timedelta
from faker import Faker

fake = Faker("pt_BR")

def gerar_produto(produto_id: int, categoria: str):
    subcategorias = {
        "livros": ["literatura_brasileira", "literatura_estrangeira", "infantil", "didático"],
        "cds": ["rock", "pop", "sertanejo", "clássico"]
    }
    subcategoria = random.choice(subcategorias[categoria])
    preco = round(random.uniform(15, 120), 2)
    estoque = random.randint(0, 300)
    data_cadastro = datetime.utcnow() - timedelta(days=random.randint(0, 365))
    tags = fake.words(nb=random.randint(2, 5))

    return {
        "produto_id": f"P{produto_id:04d}",
        "nome": fake.sentence(nb_words=3),
        "categoria": categoria,
        "subcategoria": subcategoria,
        "preco": preco,
        "estoque": estoque,
        "data_cadastro": data_cadastro.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "tags": tags,
        "vendido_30dias": random.randint(0, 200)
    }

if __name__ == "__main__":
    produtos = []
    produto_id = 1

    for _ in range(10):
        produtos.append(gerar_produto(produto_id, "livros"))
        produto_id += 1
    for _ in range(10):
        produtos.append(gerar_produto(produto_id, "cds"))
        produto_id += 1

    # --- Caminho para salvar um diretório acima
    url_base = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.abspath(os.path.join(url_base, '..', "produtos.json"))

    with open(file_path, "w", encoding="utf-8") as f:
        json.dump(produtos, f, ensure_ascii=False, indent=2)

    print(f"Arquivo produtos.json gerado em: {file_path}")
