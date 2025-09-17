# Collection Pedido Venda

## Grupo

| RA | Nome |
| -- | -- |
| 2500794 | Jaqueline Souza Medeiros |
| 2502198 | Emanuelle Müller Tadaiesky |

## Justificativa 

### Estrutura

A estrutura dos documentos é a seguinte:

```json
{
    "id_pedido": 1,
    "id_cliente": 1,
    "dthr_pedido": ISODate("2025-07-07T23:09:13Z"),
    "produtos": [
        {
            "produto_id": 1,
            "nome": "Thriller",
            "categoria": "cd",
            "quantidade": 2,
            "preco_unitario": 539.42
        },
        {
            "produto_id": 2,
            "nome": "Dom Casmurro",
            "categoria": "livro",
            "quantidade": 1,
            "preco_unitario": 17.76
        }
    ],
    "valor_total": 1096.96,
    "entrega": {
        "estado": "RJ"
    }
}
```

Um mesmo documento pode ter **n** produtos no mesmo pedido, há uma certa redundância como o nome e a categoria dos produtos podendo ser repetidas, mas todas as informações básicas para responder as perguntas do negócio podem ser feitas em apenas uma _collection_.

A chave `entrega` é um dicionário com apenas um item **estado**, pois a ideia era ele poder receber um endereço completo e não ter apenas só o estado jogado na estrutura do documento, a nível de exercício assim ficou mais complexo, mas é mais apto a receber mudanças futuras mantendo uma estrutura semelhante. Se quisessemos passar a adicionar o endereço completo poderíamos simplesmente adicionar dentro da chave `entrega`.

### Perguntas

Optei por responder todas as perguntas, pois eu queria aprender/praticar.