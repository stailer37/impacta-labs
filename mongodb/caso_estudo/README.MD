## Grupo
Matheus Medeiros de Carvalho,
Fábio de Oliveira Jacob,
Andre Luiz da Silveira,
Angelo Spinardi

## Justificativa da Modelagem

Uma coleção unificada (compras):

    Reduz redundâncias, pois todas as compras estão em um único local.
    Facilita a inclusão de novos tipos de produtos no futuro, pois a categoria é um campo no documento.

Campos estruturados:

    O campo cliente armazena informações específicas do cliente.
    O campo produto é aninhado para facilitar consultas relacionadas ao tipo de produto e nome.
    O campo click_stream permite acompanhar o comportamento do cliente antes de comprar.

Flexibilidade para expansão:

    Novos produtos podem ser adicionados apenas com uma nova categoria no campo produto.categoria.