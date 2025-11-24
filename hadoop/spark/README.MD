# Introdução

O Apache Spark é um framework de processamento de dados em larga escala, que permite o processamento de dados em memória e em disco. O Spark é amplamente utilizado para processamento de dados em tempo real e batch, além de suportar diversas linguagens de programação, como Scala, Java, Python e R.

Seus principais componentes são:
- **Spark Core**: o núcleo do Spark, responsável pelo gerenciamento de memória, execução de tarefas e agendamento de jobs.
- **Spark SQL**: módulo para processamento de dados estruturados e consulta a bancos de dados relacionais.
- **Spark Streaming**: módulo para processamento de dados em tempo real, permitindo o processamento de fluxos de dados contínuos.
- **MLlib**: biblioteca de aprendizado de máquina para construção de modelos preditivos.
- **GraphX**: módulo para processamento de grafos e análise de redes sociais.

Além disso, sua unidade de execução é baseada em DAG (Directed Acyclic Graph), o que permite otimizar o processamento de dados e melhorar a performance.
- **RDD (Resilient Distributed Dataset)**: a unidade fundamental de dados do Spark, que permite o processamento paralelo e tolerância a falhas. Os RDDs são imutáveis e podem ser criados a partir de dados em disco ou em memória.
- **DataFrame**: uma abstração de dados estruturados, semelhante a uma tabela em um banco de dados relacional. Os DataFrames permitem consultas SQL e operações de transformação de dados.

## Objetivo

Neste exercício iremos explorar diversas funcionalidades do Spark para processamento de dados.

### Tempo estimado

:hourglass_flowing_sand: 60 minutos

### Roteiro de atividades

- **A)** Conhecendo os consoles interativos do Spark  
- **B)** Interagindo com a API de processamento batch do Spark  
- **C)** Interagindo com a API streaming do Spark  
- **D)** Desafio

---

# Atividades

## Iniciar a VM

> Para importar a máquina virtual no [VirtualBox](https://www.virtualbox.org/wiki/Downloads) é necessário instalar também o pacote de extensão.
- Após instalar o VirtualBox, basta selecionar e clicar duas vezes no arquivo `cloudera-quickstart-vm-5.13.0-0-virtualbox.ovf`.
  - O processo de importação pode demorar alguns minutos, pois a máquina virtual é grande (cerca de 5 GB).

- Antes de inicializar a máquina virtual, certifique-se de ter habilitado a opção de rede `Bridged Adapter` para que a máquina virtual tenha acesso à internet e possa ser acessada pela sua máquina.
  - Clique com o botão direito do mouse na máquina virtual e selecione `Configurações` > `Rede` > `Adaptador 1` > `Conectado a` > `Placa em modo Bridge`.

- Clique em `OK` para salvar as alteraçõe e inicie a máquina virtual clicando com o botão direito do mouse e selecionando `Iniciar`.

## A) Conhecendo os consoles interativos do Spark

Objetivo: Familiarizar-se com os ambientes interativos do Spark, que são excelentes para exploração e prototipação de código.

1. Inicie console `spark-shell` para scala
- Em um terminal linux, execute o comando:
    ```shell
    spark-shell
    ```

- **Saída Esperada**
    ```text
    Setting default log level to "WARN".
    To adjust logging level use sc.setLogLevel(newLevel).
    SLF4J: Class path contains multiple SLF4J bindings.
    ...
    Welcome to
        ____              __
        / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
    /___/ .__/\_,_/_/ /_/\_\   version 1.6.0
        /_/
    ...
    scala>
    ```

2. Crie um arquivo arquivo de testes
- Abra um editor de texto (gedit) e crie um arquivo com o nome `exercicio_spark.txt`
![gedit](./resources/images/1_gedit.png)  
- Cole o conteúdo abaixo:
    ```text
    # Inicio
    Teste Spark !!!
    Teste Spark !!!
    Teste Spark !!!
    Teste Spark !!!
    Teste Spark !!!
    Teste Spark !!!
    Teste Spark !!!
    Teste Spark !!!
    Teste Spark !!!
    # Fim
    ```
- Salve o arquivo em `/home/cloudera/exercicio_spark.txt`

3. Conte as linhas do arquivo usando o _shell scala_
- No terminal aberto com o spark-shell, execute o comando abaixo
    ```scala
    val rdd = sc.textFile("file:///home/cloudera/exercicio_spark.txt")
    ```

- **Saída Esperada**
    ```text
    rdd: org.apache.spark.rdd.RDD[String] = file:///home/cloudera/exercicio_spark.txt MapPartitionsRDD[7] at textFile at <console>:27
    ```

- Execute a action para contar a quantidade de registros
    ```scala
    rdd.count()
    ```

- **Saída Esperada**
    ```text
    res1: Long = 12
    ```

- Aperte `CTRL+D` duas vezes e feche o terminal

4. Execute a mesma contagem em um terminal `pyspark`
- Em outro terminal linux, execute o comando:
    ```shell
    pyspark
    ```

- **Saída Esperada**
    ```text
    ...
    Welcome to
        ____              __
        / __/__  ___ _____/ /__
        _\ \/ _ \/ _ `/ __/  '_/
        /__ / .__/\_,_/_/ /_/\_\   version 1.6.0
        /_/



    Using Python version 2.6.6 (r266:84292, Jul 23 2015 15:22:56)
    SparkContext available as sc, HiveContext available as sqlContext.
    >>>
    ```

- Crie o RDD e faça a contagem de linhas
    ```python
    rdd = sc.textFile("file:///home/cloudera/exercicio_spark.txt")
    rdd.count()
    ```

- **Saída Esperada**
    ```
    12
    ```

## B) Processamento em Batch com a API de RDDs

Objetivo: Aprender a carregar, transformar e salvar dados em um cenário de processamento em lote (_batch_), com foco na análise do código.

5. Crie um arquivo com 100K transações de cartão de crédito
- Copie o conteúdo do script `live_transactions_generator.py` armazenado em `./resources/scripts` para um novo documento no gedit
- Salve o arquivo em `/home/cloudera/live_transactions_generator.py`
- Abra um novo terminal Linux e execute o comando abaixo para gerar um arquivo com 100000 transações de cartão
    ```shell
    python live_transactions_generator.py 100000 > transactions_100k.csv
    ```

6. Copie o arquivo resultante para o HDFS
- Para isso, execute o comando abaixo
    ```shell
    hdfs dfs -copyFromLocal transactions_100k.csv /user/cloudera/
    ```

- Usando a interface do HUE, navegue até browser de arquivos e verifique o que arquivo foi inserido no HDFS
![uploaded_file](./resources/images/2_uploaded_file.png)  

7. Crie um RDD a partir do arquivo inserido no HDFS e filtre apenas as transações aprovadas
- No pyspark shell, execute:
    ```python
    transactions = sc.textFile("hdfs:///user/cloudera/transactions_100k.csv")
    ```

8. Conte a quantidades de transações aprovadas e canceladas usando a função `filter`
- Crie 2 novos RDD's filtrando as transações
    ```python
    aprovadas = transactions.filter(lambda l: "APROVADA" in l)
    canceladas = transactions.filter(lambda l: "CANCELADA" in l)
    ```

- Visualize o funcionamento do filtro aplicado
    ```python
    aprovadas.take(5)
    ```

- **Saída Esperada**
    ```text
    [u'2017-09-27 22:25:27,jfta0igc,Loja3,APROVADA,BRL,9178', u'2017-09-27 22:25:27,1a6o9j0h,Loja6,APROVADA,USD,1236', u'2017-09-27 22:25:27,v2nstwce,Loja2,APROVADA,BRL,8694', u'2017-09-27 22:25:27,31y6bwcr,Loja2,APROVADA,USD,7081', u'2017-09-27 22:25:27,m1w3zy8a,Loja7,APROVADA,USD,7000']
    ```

- Execute a ação de contagem de registros
    ```python
    aprovadas.count()
    canceladas.count()
    ```

- **Saída Esperada**
    ```
    33318 - Os valores são aleatórios, então a saída pode ser diferente
    ```

> [!WARNING]
> Como geramos 100K transações, o número de transações aprovadas e canceladas pode variar a cada execução do script.

### Entendendo o Código: Filter e Funções Lambda
Vamos detalhar a linha aprovadas = transactions.filter(lambda linha: "APROVADA" in linha):

- `transactions.filter(...)`: `filter` é uma transformação do Spark. Ela cria um novo RDD contendo apenas os elementos do RDD original que satisfazem uma determinada condição.
- `lambda l: ...`: Esta é uma função anônima (lambda) em Python. É uma forma curta de escrever uma função. Aqui, `l` (linha) é o nome que damos para cada elemento do RDD transactions à medida que ele é processado.
- `"APROVADA" in linha`: Esta é a condição. Para cada linha do RDD, o Python verifica se a _string_ `"APROVADA"` existe dentro dela. A expressão retorna `True` ou `False`.

Em resumo: O Spark percorre cada linha do RDD _transactions_, aplica a função _lambda_ e, se o resultado for `True`, a linha é incluída no novo RDD aprovadas.

9. Materialize o RDD de transações canceladas no HDFS
- Execute
    ```python
    canceladas.saveAsTextFile("/user/cloudera/transacoes_canceladas.csv")
    ```
- No navegador de arquivos do HUE, note que uma pasta é criada para conter arquivos com as linhas exportadas.
![canceladas](./resources/images/3_canceladas.png)  

10. Calcule o valor transacionado por tipo de moeda
- Crie um *key-value* RDD e faça a conversão de tipo usando maps
    ```python
    kv_currency_amount = aprovadas.map(lambda l: l.split(',')).map(lambda cols: (cols[4], int(cols[5])))
    kv_currency_amount.take(10)
    ```

- **Saída Esperada**
    ```text
    [(u'BRL', 9178), (u'USD', 1236), (u'BRL', 8694), (u'USD', 7081), (u'USD', 7000), (u'USD', 1211), (u'BRL', 5438), (u'USD', 4785), (u'BRL', 6563), (u'USD', 1630)]
    ```

- Agrupe os valores por moeda e some os valores transacionados
    ```python
    kv_currency_amount.reduceByKey(lambda a, b: a + b).collect()
    ```

- **Saída Esperada**
    ```text
    [(u'BRL', 84454529), (u'USD', 83530616)]
    ```

### Entendendo o Código: map e reduceByKey

Vamos analisar o fluxo de dados passo a passo:

1. `aprovadas.map(lambda linha: linha.split(","))`
- `map`: É uma transformação que aplica uma função a cada elemento de um RDD para criar um novo RDD. O RDD resultante sempre terá o mesmo número de elementos que o original.
- O que faz: Para cada linha (que é uma string como `"2017-09-27,jfta0igc,Loja3,APROVADA,BRL,9178"`), a função `split(",")` a transforma em uma lista de strings: `["2017-09-27", "jfta0igc", "Loja3", "APROVADA", "BRL", "9178"]`.
- Resultado: Um novo RDD onde cada elemento é uma lista de strings.

2. `.map(lambda colunas: (colunas[4], int(colunas[5])))`
- Encadeamento: Note que estamos aplicando um `map` no resultado do `map` anterior. Isso é chamado de encadeamento (_chaining_) e é uma prática comum e eficiente.
- O que faz: Para cada `colunas` (a lista de strings do passo anterior), esta função cria uma tupla (um par chave-valor). A chave é `colunas[4]` (a moeda, ex: `"BRL"`) e o valor é `int(colunas[5])` (o valor da transação convertido para inteiro, ex: 9178).
- Resultado: Um RDD de pares chave-valor, como (`"BRL", 9178)`, `("USD", 1236)`, etc.

3. `kv_currency_amount.reduceByKey(lambda a, b: a + b)`
- `reduceByKey`: Esta é uma transformação poderosa que opera apenas em RDDs de pares chave-valor. Ela primeiro agrupa todos os valores que têm a mesma chave e, em seguida, aplica uma função para "reduzir" (agregar) todos os valores de cada grupo a um único valor.
- O que faz: Para a chave `"BRL"`, ela pega todos os valores associados (ex: `[9178, 8694, 5438, ...]`) e os soma usando a função `lambda a, b: a + b`.
- Resultado: Um RDD final com a soma total por moeda, como `("BRL", 84454529)`.

Este fluxo `map` -> `map` -> `reduceByKey` é a essência do processamento distribuído com Spark: preparar os dados em um formato chave-valor e depois agregar os resultados.

## C) Interagindo com a API streaming do Spark

Objetivo: Entender como o Spark processa fluxos de dados contínuos (streaming) usando o conceito de micro-lotes (micro-batches).

11. Reinicie o console pyspark com mais de 1 thread para que o Streaming não fique travado
- Pressione CTRL+D para fechar o console atual
- Execute o comando abaixo:
    ```shell
    pyspark --driver-cores 2
    ```

12. Crie um StreamingContext para poder usar a API do Spark Streaming
- Execute o comando a seguir para iniciar um StreamingContext com micro-batch executando em janelas de 10 em 10 segundos
    ```python
    from pyspark.streaming import StreamingContext
    ssc = StreamingContext(sc, 10)
    ```

13. Crie um *key-value* DStream para receber dados de um socket tcp e fazer agregação do valor transacionado por loja
    ```python
    live_transactions = ssc.socketTextStream("localhost", 4444)
    kv_store_amount = live_transactions.map(lambda l: l.split(',')).map(lambda cols: (cols[2], int(cols[5])))
    kv_store_amount.reduceByKey(lambda v1, v2: v1 + v2).pprint()
    ```

14. Visualize que o job streaming ainda não iniciou
- Aponte seu navegador para `localhost:4040`
- Note que ou não há jobs ou todos estão completos
![spark_ui_stopped](./resources/images/4_spark_ui_stopped.png)  

15. Inicie o gerador de eventos
- Em um outro terminal linux, execute:
    ```shell
    while :; do python transactions_generator.py ; done | nc -lk 4444
    ```

16. Inicie o StreamingContext para iniciar o processamento
- Execute no pyspark
    ```python
    ssc.start()
    ```

- **Saída Esperada**
    ```text
    -------------------------------------------                                     
    Time: 2017-09-28 00:18:50
    -------------------------------------------
    (u'Loja5', 609128)
    (u'Loja7', 636108)
    (u'Loja1', 490032)
    (u'Loja3', 529946)
    (u'Loja4', 544275)
    (u'Loja6', 708482)
    (u'Loja2', 564100)
    ...
    -------------------------------------------                                     
    Time: 2017-09-28 00:19:00
    -------------------------------------------
    (u'Loja5', 618156)
    (u'Loja7', 717384)
    (u'Loja1', 629586)
    (u'Loja3', 606443)
    (u'Loja4', 596774)
    (u'Loja6', 614073)
    (u'Loja2', 699521)
    ```

- Visualize na interface web do Spark UI
![spark_ui_running](./resources/images/5_spark_ui_running.png)  
> [!NOTE]
> Note que há 1 job de streaming executando e um número crescente de jobs de micro-batch completados

---
## Desafios

Quer um desafio maior?

1. Crie um *key-value* RDD que contenha o seguinte mapeamento de chave e valor
  ```
  Loja1 -> Americanas
  Loja2 -> Magazine Luíza
  Loja3 -> Ricardo Eletro
  Loja4 -> Privalie
  Loja5 -> Netshoes
  Loja6 -> Walmart
  Loja7 -> Submarino
  ```
  > [!NOTE]
  > Utilize uma operação de `join` para fornecer uma visão de saída com os nomes das lojas reais

2. Crie um script python com o conteúdo a seguir:
  ```python
  from pyspark import SparkContext
  sc = SparkContext("local[1]", "Desafio 2")
  rdd = sc.parallelize([1, 2, 3, 4, 5])
  print rdd.collect()
  ```
  e tente submetê-lo como um job com spark standalone
  > [!TIP]
  > **Dica:** O parâmetro `py-files` permite enviar arquivos python para o cluster Spark

## Conteúdo Extra

### O que é Data Skew?

Data Skew (ou assimetria de dados) ocorre quando os dados não são distribuídos uniformemente entre as partições. Em operações de `groupBy` ou `join`, isso significa que algumas chaves têm um volume de dados desproporcionalmente maior que outras. O resultado é que, enquanto 99 tarefas terminam em segundos, uma única tarefa pode levar horas para processar a partição "pesada", tornando-se o gargalo de todo o job.

### Como detectar Data Skew?

A Spark UI é sua melhor amiga. Na aba "Stages", procure por um estágio que está demorando muito. Dentro dele, olhe a lista de tarefas. Se a maioria das tarefas tem uma duração similar, mas algumas poucas têm uma duração muito maior e processam muito mais dados, você encontrou o _Data Skew_.

### Como resolver Data Skew?

A ideia é quebrar a chave assimétrica em múltiplas chaves _"salted"_ para distribuir a carga entre mais tarefas.

Cenário: Um join entre um _DataFrame_ de vendas (`vendas_df`) e um de usuários (`usuarios_df`), onde um ID de usuário (ex: -1 para "usuário não logado") representa 90% das vendas.

```python
from pyspark.sql.functions import col, lit, rand, concat, floor

# 1. Crie uma nova coluna com um "sal" aleatório (ex: de 0 a 9)
salt_range = 10
vendas_com_sal = vendas_df.withColumn('salt', floor(rand() * salt_range))

# 2. Crie a nova chave de join salted
vendas_com_sal = vendas_com_sal.withColumn(
    'salted_user_id',
    concat(
        col('user_id'),
        lit('_'),
        col('salt')
    )
)

# --- Lado do DataFrame PEQUENO (usuarios_df) ---

# 3. "Exploda" o DataFrame pequeno para que ele possa dar join com todas as chaves salgadas
usuarios_explodido = usuarios_df.crossJoin(spark.range(salt_range).withColumnRenamed('id', 'salt'))

# 4. Crie a mesma chave de join salgada
usuarios_explodido = usuarios_explodido.withColumn('salted_user_id', 
                                                   concat(col('user_id'), lit('_'), col('salt')))

# 5. Execute o join com a chave salgada!
resultado_final = vendas_com_sal.join(usuarios_explodido, ['salted_user_id'])
```

A chave problemática `user_id = -1` foi transformada em 10 chaves diferentes (`-1_0`, `-1_1`, ..., `-1_9`). A carga de trabalho que antes estava em uma única tarefa agora está distribuída entre 10 tarefas, eliminando o gargalo.

### Boas Práticas para Evitar Erros de OutOfMemory (OOM)

O erro de `java.lang.OutOfMemoryError` é um dos problemas mais comuns e frustrantes no Spark. Ele pode acontecer no _Driver_ ou nos _Executors_.

As causas mais comuns de OOM no Executor:
1. Partições muito grandes: Uma única partição não cabe na memória do Executor.
2. collect() em dados grandes: df.collect() tenta trazer todos os dados do DataFrame para a memória do Driver. Nunca faça isso em um DataFrame grande. Use take(), show() ou salve o resultado em disco.
3. groupByKey: Evite groupByKey a todo custo. Ele agrupa todos os valores de uma chave na memória antes de aplicar a função. Use reduceByKey ou aggregateByKey (para RDDs) ou groupBy().agg() (para DataFrames), que realizam a agregação de forma mais eficiente.

Estratégias e Boas Práticas para Evitar OOM:
| Técnica | Descrição | Exemplo de Código |
| :--- | :--- | :--- |
| **Aumentar Partições** | Se suas partições são muito grandes, reparticione para criar partições menores que caibam na memória. | `df.repartition(500)` |
| **Broadcast Join** | Se você está fazendo um join entre uma tabela grande e uma pequena (ex: < 100MB), use um `broadcast join`. O Spark enviará uma cópia da tabela pequena para cada Executor, evitando um shuffle caro e que consome muita memória. | `from pyspark.sql.functions import broadcast`<br>`df_grande.join(broadcast(df_pequeno), ['id'])` |
| **Filtrar Cedo (`Predicate Pushdown`)** | Sempre aplique seus filtros (`WHERE` ou `filter()`) o mais cedo possível no seu código. O Catalyst Optimizer já faz isso (Predicate Pushdown), mas ser explícito ajuda a garantir que você leia o mínimo de dados possível. | `spark.read.parquet('...').filter(col('data') > '2023-01-01')` |
| **Usar `persist()` com Sabedoria** | Se você for usar um DataFrame várias vezes, use `df.persist(StorageLevel.MEMORY_AND_DISK)`. O Spark o manterá em memória (e em disco se não couber). Isso evita que ele seja recalculado a cada ação. | `df_processado = df.filter(...).groupBy(...)`<br>`df_processado.persist()`<br>`df_processado.count()`<br>`df_processado.write.parquet('...')` |
| **Escolher o Formato Certo** | Prefira formatos de arquivo colunares como **Parquet** ou **ORC**. Eles são mais eficientes para leitura e permitem que o Spark leia apenas as colunas que você precisa (*column pruning*). | `df.write.parquet('path/to/output')` |

### API de DataFrame do Spark
Quando utilizamos a API de DataFrame (ou Dataset) no Apache Spark, não estamos apenas usando uma interface mais amigável que os RDDs; estamos, na verdade, desbloqueando um ecossistema de otimizações automáticas e poderosas que são a base da alta performance do Spark. Este documento detalha os principais componentes por trás dessa "mágica".

A API de DataFrame nos fornece um rico conjunto de otimizações, tais como:
| Componente de Otimização | Descrição Detalhada |
| :--- | :--- |
| **Adaptive Query Execution (AQE)** | Otimiza dinamicamente os planos de consulta em tempo de execução, com base em estatísticas e padrões de execução. É uma otimização "inteligente" que ajusta a estratégia do job *enquanto* ele está rodando. |
| **In-Memory Columnar Storage (Tungsten)** | Um formato de armazenamento em memória que organiza os dados em colunas, em vez de linhas. Isso permite uma performance analítica muito mais eficiente e reduz drasticamente o consumo de memória. |
| **Estatísticas Nativas (Built-in Statistics)** | Coleta automática de estatísticas (como valores mínimos/máximos e contagem de nulos) ao salvar dados em formatos otimizados (Parquet, Delta), permitindo um planejamento de consulta mais inteligente. |
| **Catalyst Optimizer e Photon** | O **Catalyst** é o framework de otimização de consultas do Spark SQL, enquanto o **Photon** é um motor de execução de última geração que acelera ainda mais o processamento. |

Quando um DataFrame é avaliado (ou seja, quando uma ação é chamada), o Driver cria um plano de execução otimizado através de uma série de transformações, convertendo o plano lógico em um plano de execução físico eficiente que minimiza o uso de recursos e o tempo de execução.

O fluxo é o seguinte:

**Plano Lógico Não Resolvido → Plano Lógico Analisado → Plano Lógico Otimizado → Plano Físico**

1.  **Plano Lógico Não Resolvido**: O Spark cria uma representação abstrata da sua consulta. Neste ponto, ele ainda não verificou se as tabelas ou colunas que você usou realmente existem.
2.  **Análise**: O Spark consulta seu catálogo (Metastore) para resolver e validar os nomes de tabelas, colunas e funções, criando um **Plano Lógico Analisado**.
3.  **Otimização Lógica**: O Catalyst Optimizer aplica dezenas de regras (como Predicate Pushdown) ao plano lógico para reestruturá-lo de forma mais eficiente, resultando em um **Plano Lógico Otimizado**.
4.  **Otimização Física**: O Spark gera um ou mais **Planos Físicos** a partir do plano lógico otimizado. Um plano físico descreve exatamente *como* a consulta será executada (ex: usar um `Hash Join` ou um `Sort-Merge Join`). Se houver mais de um plano, o otimizador baseado em custo escolhe o melhor.
5.  **Geração de Código**: Finalmente, o Tungsten entra em ação, gerando bytecode otimizado para a CPU a partir do plano físico escolhido, garantindo a máxima performance durante a execução.

### Referências
- [Apache Spark Documentation](https://spark.apache.org/docs/latest/sql-performance-tuning.html)
- [Understanding Spark's Catalyst Optimizer](https://databricks.com/glossary/what-is-catalyst-optimizer)
- [Adaptive Query Execution in Spark](https://www.databricks.com/blog/2020/05/29/adaptive-query-execution-speeding-up-spark-sql-at-runtime.html)
- [Tungsten: Bringing Spark Closer to Bare Metal](https://databricks.com/blog/2015/03/31/tungsten-bringing-spark-closer-to-bare-metal.html)