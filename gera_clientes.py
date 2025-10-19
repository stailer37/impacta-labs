import os
import json
import random
from datetime import datetime, timedelta
from faker import Faker

fake = Faker("pt_BR")

def gerar_evento(evento_id: int, produtos: list):
    agora = datetime.utcnow()
    data_cadastro = agora - timedelta(days=random.randint(0, 365))

    cliques = []
    for _ in range(random.randint(1, 3)):
        produto = random.choice(produtos)
        cliques.append({
            "produto_id": produto["produto_id"],
            "nome": produto["nome"],
            "categoria": produto["categoria"],
            "subcategoria": produto["subcategoria"],
            "preco": produto["preco"],
            "timestamp": (agora - timedelta(minutes=random.randint(1, 120))).strftime("%Y-%m-%dT%H:%M:%SZ")
        })

    return {
        "evento_id": f"cli_{agora.year}_{evento_id:03d}",
        "tipo": "CLIENTE_CRIADO",
        "timestamp": agora.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "dados": {
            "cliente_id": f"C{random.randint(1000, 9999)}",
            "nome": fake.name(),
            "email": fake.email(),
            "endereco": {
                "rua": fake.street_address(),
                "cidade": fake.city(),
                "estado": fake.estado_sigla(),
                "cep": fake.postcode()
            },
            "data_cadastro": data_cadastro.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "cliques_recentes": cliques
        }
    }

if __name__ == "__main__":
    # --- Caminho para produtos.json (um diretório acima)
    url_base = os.path.dirname(os.path.abspath(__file__))
    produtos_path = os.path.abspath(os.path.join(url_base, '..', "produtos.json"))
    eventos_path = os.path.abspath(os.path.join(url_base, '..', "clientes.json"))

    # --- Carrega produtos
    with open(produtos_path, "r", encoding="utf-8") as f:
        produtos = json.load(f)

    # --- Gera eventos
    eventos = [gerar_evento(i, produtos) for i in range(1, 6)]

    # --- Salva eventos.json
    with open(eventos_path, "w", encoding="utf-8") as f:
        json.dump(eventos, f, ensure_ascii=False, indent=2)

    print(f"Arquivo eventos.json gerado em: {eventos_path}")
