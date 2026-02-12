# Introdução

O MapReduce v2 utiliza o _YARN (Yet Another Resource Negotiator)_ como gerenciador de recursos. O YARN é responsável por alocar os recursos do cluster e executar os jobs MapReduce.
O YARN é composto por dois componentes principais:
- _ResourceManager_: gerencia os recursos do cluster e aloca os containers para os jobs MapReduce.
- _NodeManager_: gerencia os containers em cada nó do cluster e executa os tasks dos jobs MapReduce.
Além disso, o YARN também possui um componente chamado _ApplicationMaster_, que é responsável por gerenciar a execução de um job MapReduce específico.

## Objetivo

Neste exercício iremos executar um job MapReduce para contar palavras de um arquivo com links do Wikipedia que será carregado no HDFS.

### Tempo estimado

:hourglass_flowing_sand: 30 minutos

### Roteiro de atividades

- **A)** Prepação dos dados para execução
- **B)** Executar o programa de MapReduce
- **C)** Gerenciar jobs MapReduce em execução
- **D)**: Desafio

---

# Atividades

## Iniciar a VM

> Para importar a máquina virtual no [VirtualBox](https://www.virtualbox.org/wiki/Downloads) é necessário instalar também o pacote de extensão.
- Após instalar o VirtualBox, basta selecionar e clicar duas vezes no arquivo `cloudera-quickstart-vm-5.13.0-0-virtualbox.ovf`.
  - O processo de importação pode demorar alguns minutos, pois a máquina virtual é grande (cerca de 5 GB).

- Antes de inicializar a máquina virtual, certifique-se de ter habilitado a opção de rede `Bridged Adapter` para que a máquina virtual tenha acesso à internet e possa ser acessada pela sua máquina.
  - Clique com o botão direito do mouse na máquina virtual e selecione `Configurações` > `Rede` > `Adaptador 1` > `Conectado a` > `Placa em modo Bridge`.

- Clique em `OK` para salvar as alteraçõe e inicie a máquina virtual clicando com o botão direito do mouse e selecionando `Iniciar`.

## A) Prepação dos dados para execução

1. Num terminal linux, execute o comando para verificar se o diretório aluno já existe no HDFS
```shell
hdfs dfs -ls /user
```

> [!NOTE]
> Caso não existir, crie o diretório executando o comando (no lugar de aluno, use seu nome - se quiser)
```shell
hdfs dfs -mkdir /user/aluno/
```

2. Conceda a permissão dos diretórios do HDFS para qualquer usuário
```shell
hdfs dfs -chmod -R 777 /
```

3. Abra o navegador e realize o download da base _“Freebase/Wikidata Mappings”_, disponível [neste link](https://developers.google.com/freebase/). Salve o arquivo no diretório `/home/cloudera/Downloads`

4. Descompacte o arquivo salvo
```shell
cd /home/cloudera/Downloads
gzip -d fb2w.nt.gz
```

5. Coloque o arquivo descompactado no HDFS
```shell
hdfs dfs -copyFromLocal /home/cloudera/Downloads/fb2w.nt /user/aluno/
```

## B) Executar o programa de MapReduce

### "Hello, World!" do MapReduce: WordCount

O exemplo mais clássico para ilustrar o funcionamento do MapReduce é o WordCount, um programa que conta a ocorrência de cada palavra em um conjunto de textos.

6. Execute o programa MapReduce de exemplos (`hadoop-mapreduce-examples.jar`) utilizando a função `wordcount` que conta a quantidade de palavras em um arquivo no HDFS.
```shell
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar wordcount /user/aluno/ /user/aluno/output/
```

- `/caminho/para/hadoop-mapreduce-examples.jar`: O caminho para o JAR que contém os exemplos.
- `wordcount`: O nome do programa a ser executado.
- `/diretorio/de/entrada`: O diretório no HDFS contendo os arquivos de texto.
- `/diretorio/de/saida`: O diretório no HDFS onde o resultado será salvo.

> [!IMPORTANT]
> Aguarde a finalizacao do job e verifique a saida

![impacta](./resources/images/1_job_running.png)

7. Verifique se a contagem de palavras ocorreu com sucesso
```shell
hdfs dfs -ls /user/aluno/output
```

**Saída esperada**
```
Found 2 items
-rw-r--r--   1 cloudera supergroup          0 2017-09-04 15:46 /user/aluno/output/_SUCCESS
-rw-r--r--   1 cloudera supergroup  176870257 2017-09-04 15:46 /user/aluno/output/part-r-00000
```

- Execute o comando abaixo para visualizar a saída do arquivo
```shell
hdfs dfs -cat /user/aluno/output/part-r-00000 | head
hdfs dfs -cat /user/aluno/output/part-r-00000 | tail
```

8. Visualize os logs de execução do job executado pelo browser
   - No browser acesse a página do [ResourceManager](http://{ip_address}:8088)
   - Clique no ID do job executado (ex: `application_1504562894662_0001`)
   - Clique em `logs` para visualizar os logs da execução

#### Análise Profunda do Código WordCount

Vamos analisar o código-fonte Java do exemplo WordCount para entender como ele implementa o paradigma MapReduce


```java
package org.apache.hadoop.examples;

import java.io.IOException;
import java.util.StringTokenizer;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class WordCount {

  public static class TokenizerMapper
       extends Mapper<Object, Text, Text, IntWritable>{

    private final static IntWritable one = new IntWritable(1);
    private Text word = new Text();

    public void map(Object key, Text value, Context context
                    ) throws IOException, InterruptedException {
      StringTokenizer itr = new StringTokenizer(value.toString());
      while (itr.hasMoreTokens()) {
        word.set(itr.nextToken());
        context.write(word, one);
      }
    }
  }

  public static class IntSumReducer
       extends Reducer<Text,IntWritable,Text,IntWritable> {
    private IntWritable result = new IntWritable();

    public void reduce(Text key, Iterable<IntWritable> values,
                       Context context
                       ) throws IOException, InterruptedException {
      int sum = 0;
      for (IntWritable val : values) {
        sum += val.get();
      }
      result.set(sum);
      context.write(key, result);
    }
  }

  public static void main(String[] args) throws Exception {
    Configuration conf = new Configuration();
    Job job = Job.getInstance(conf, "word count");
    job.setJarByClass(WordCount.class);
    job.setMapperClass(TokenizerMapper.class);
    job.setCombinerClass(IntSumReducer.class);
    job.setReducerClass(IntSumReducer.class);
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(IntWritable.class);
    FileInputFormat.addInputPath(job, new Path(args[0]));
    FileOutputFormat.setOutputPath(job, new Path(args[1]));
    System.exit(job.waitForCompletion(true) ? 0 : 1);
  }
}
```

#### Explicação das Partes
1. Classe `TokenizerMapper` (O Mapeador)

O Mapper é responsável por processar cada linha do arquivo de entrada. Sua função é quebrar a linha em palavras e emitir um par chave-valor para cada palavra encontrada. A chave é a própria palavra e o valor é o número 1, indicando uma ocorrência.

- `extends Mapper<Object, Text, Text, IntWritable>`: Define os tipos de dados de entrada e saída: a chave de entrada é um `Object` (o offset da linha no arquivo), o valor de entrada é `Text` (a linha), a chave de saída é `Text` (a palavra) e o valor de saída é `IntWritable` (o número 1).

- `map(Object key, Text value, Context context)`: Este método é executado para cada linha do arquivo. Ele usa `StringTokenizer` para dividir a linha em palavras e, para cada palavra, escreve o par `<palavra, 1>` no contexto.

2. Classe IntSumReducer (O Redutor)

O Reducer recebe os dados da fase de _Shuffle_ e _Sort_. Para cada chave (palavra), ele recebe uma lista de todos os valores associados a ela (uma lista de 1s) e os agrega.

- `extends Reducer<Text,IntWritable,Text,IntWritable>`: Define os tipos de entrada e saída, que neste caso são os mesmos do Mapper.
- `reduce(Text key, Iterable<IntWritable> values, Context context)`: Este método é executado para cada chave única. Ele itera sobre a lista de valores (`values`), soma todos eles para obter a contagem total da palavra e escreve o resultado final, o par `<palavra, contagem_total>`.

3. Método main (O Driver)

O método main é o ponto de entrada do programa. Ele é responsável por configurar e submeter o job MapReduce ao cluster.

- `Configuration conf = new Configuration()`: Cria um objeto de configuração.
- `Job job = Job.getInstance(conf, "word count")`: Cria o job, dando-lhe um nome.
- `job.setJarByClass(...)`: Informa ao framework qual classe contém o job.
- `job.setMapperClass(...)` e `job.setReducerClass(...)`: Define as classes do Mapper e do Reducer.
- `job.setOutputKeyClass(...)` e `job.setOutputValueClass(...)`: Define os tipos de dados da saída final.
- `FileInputFormat.addInputPath(...)` e `FileOutputFormat.setOutputPath(...)`: Define os diretórios de entrada e saída no HDFS.
- `job.waitForCompletion(true)`: Submete o job e aguarda sua conclusão.

## C) Gerenciar jobs MapReduce em execução

9. Execute novamente o job de contagem de palavras que acabamos de executar, alterando o diretório de saída para `output2`
```shell
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar wordcount /user/aluno/fb2w.nt /user/aluno/output2/
```

10. Enquanto o job está executando, abra outro terminal linux e execute o comando para listar os em execução
```shell
hadoop job -list
```

**Saída esperada**
```
Total jobs:1
JobId	     State	     StartTime	    UserName	       Queue	  Priority	 UsedContainers	 RsvdContainers	 UsedMem	 RsvdMem NeededMem	   AM info
job_1504554194266_0002	   RUNNING	 1504561700010	    cloudera	root.cloudera	    NORMAL	              2	              0	   3072M	      0M     3072M	http://quickstart.cloudera:8088/proxy/application_1504554194266_0002/
```

11. Em seguida, execute um kill para interromper esse job
```shell
hadoop job -kill job_1446639780394_0002
```
---
## Desafio

Já terminou o exercício? Quer um desafio maior? Então quero ver você resolver...

1. Execute mais uma vez o job MapReduce e visualize e acompanhe os logs pela interface web enquanto o job executa.

2. Análise como o arquivo fb2w ficou distribuído no HDFS acessando a página do [NameNode](http://{ip_address}:50070) por meio do browser.

3. Execute novamente o job MapReduce de contagem de palavras com um outro arquivo que você deve criar contendo pelo menos 3 linhas.

## Conteúdo Avançado:

O código do WordCount inclui uma linha crucial para otimização: `job.setCombinerClass(IntSumReducer.class)`. Isso nos introduz a dois componentes importantes: o _Combiner_ e o _Partitioner_.

### O Combiner: O "Mini-Reducer"

O Combiner é uma classe opcional que executa uma agregação local no nó de cada Mapper antes que os dados sejam enviados pela rede para os _Reducers_. Sua principal função é reduzir a quantidade de dados transferidos, o que pode melhorar drasticamente a performance do job.

No caso do WordCount, a mesma classe `IntSumReducer` é usada como Combiner. Isso significa que, se um Mapper processar um texto com a palavra "World" duas vezes, em vez de enviar `<World, 1>` e `<World, 1>` pela rede, o Combiner os agrega localmente e envia apenas `<World, 2>`. O Combiner só pode ser usado quando a operação de redução é comutativa e associativa, como a soma.

### O Partitioner: O Distribuidor de Chaves

O _Partitioner_ controla como os dados intermediários são distribuídos entre os _Reducers_. Sua função é garantir que todas as ocorrências de uma mesma chave sejam enviadas para o mesmo Reducer. O _Partitioner_ não reduz a quantidade de dados, apenas a distribui.

Por padrão, o Hadoop usa o `HashPartitioner`, que calcula o hash da chave e o divide pelo número de _Reducers_ para determinar para qual deles o dado será enviado. É possível implementar um _Partitioner_ customizado para controlar a distribuição de chaves, o que pode ser útil para balancear a carga ou garantir uma ordenação específica na saída.

### Leituras Adicionais

- [Databricks. "O que é MapReduce?".](https://www.databricks.com/br/glossary/mapreduce)

- [Medium. "Hadoop Map Reduce: O que é, sua arquitetura e como é executado na prática". Disponível em:](https://medium.com/@krupck/hadoop-map-reduce-o-que-%C3%A9-sua-arquitetura-e-como-%C3%A9-executado-na-pr%C3%A1tica-eb1ccacb112f)

- [Apache Hadoop. "MapReduce Tutorial". Disponível em:](https://hadoop.apache.org/docs/stable/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html)