import os
import json
import random
from datetime import datetime, timedelta

def gerar_venda(evento_id: int, clientes: list, produtos: list):
    agora = datetime.utcnow()

    # escolher cliente
    cliente_evento = random.choice(clientes)
    cliente_id = cliente_evento["dados"]["cliente_id"]
    estado_cliente = cliente_evento["dados"]["endereco"]["estado"]

    # escolher produtos para a venda
    num_itens = random.randint(1, 3)
    itens_venda = []
    valor_total = 0

    for _ in range(num_itens):
        produto = random.choice(produtos)
        qtd = random.randint(1, 3)
        valor_item = produto["preco"] * qtd
        valor_total += valor_item

        itens_venda.append({
            "produto_id": produto["produto_id"],
            "nome": produto["nome"],
            "categoria": produto["categoria"],
            "preco_unitario": produto["preco"],
            "quantidade": qtd
        })

    return {
        "evento_id": f"vnd_{agora.year}_{evento_id:03d}",
        "tipo": "VENDA_REGISTRADA",
        "timestamp": agora.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "dados": {
            "venda_id": f"V{random.randint(3000, 9999)}",
            "cliente_id": cliente_id,
            "data_venda": agora.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "valor_total": round(valor_total, 2),
            "itens": itens_venda,
            "estado_cliente": estado_cliente
        }
    }

if __name__ == "__main__":
    # --- Caminhos
    url_base = os.path.dirname(os.path.abspath(__file__))
    produtos_path = os.path.abspath(os.path.join(url_base, '..', "produtos.json"))
    clientes_path = os.path.abspath(os.path.join(url_base, '..', "eventos.json"))
    vendas_path = os.path.abspath(os.path.join(url_base, '..', "vendas.json"))

    # --- Carregar clientes e produtos
    with open(produtos_path, "r", encoding="utf-8") as f:
        produtos = json.load(f)

    with open(clientes_path, "r", encoding="utf-8") as f:
        clientes = json.load(f)

    # --- Gerar vendas
    vendas = [gerar_venda(i, clientes, produtos) for i in range(1, 6)]

    # --- Salvar vendas.json
    with open(vendas_path, "w", encoding="utf-8") as f:
        json.dump(vendas, f, ensure_ascii=False, indent=2)

    print(f"Arquivo vendas.json gerado em: {vendas_path}")
