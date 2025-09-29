# Hadoop Ecosystem Overview
Este repositório fornece uma visão geral de algumas das principais tecnologias do ecossistema Hadoop amplamente utilizadas no mercado. Abaixo, você encontrará descrições breves e links para a documentação oficial de cada tecnologia.

## HDFS
O Hadoop Distributed File System (HDFS) é um sistema de arquivos distribuído projetado para armazenar grandes volumes de dados em clusters de computadores. Ele é otimizado para alta disponibilidade, escalabilidade e tolerância a falhas, permitindo o armazenamento eficiente de dados em larga escala.
- [Laboratório de HDFS](./hadoop/hdfs/README.MD)
- [Documentação oficial do HDFS](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/HdfsUserGuide.html)

## MapReduce
O MapReduce é um modelo de programação para processamento paralelo de grandes conjuntos de dados em clusters. Ele divide tarefas em duas fases principais: Map (mapeamento) e Reduce (redução), permitindo o processamento eficiente e escalável de dados distribuídos.
- [Laboratório de MapReduce](./hadoop/mapreduce/README.MD)
- [Documentação oficial do MapReduce](https://hadoop.apache.org/docs/stable/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html)

## Hive
Apache Hive é uma infraestrutura de data warehouse construída sobre o Hadoop, que permite consultas SQL-like em grandes conjuntos de dados armazenados no HDFS. Ele fornece uma interface semelhante ao SQL para facilitar a análise e consulta de dados, tornando-o acessível para analistas e desenvolvedores que estão familiarizados com SQL.
- [Laboratório de Hive](./hadoop/hive/README.MD)
- [Documentação oficial do Hive](https://cwiki.apache.org/confluence/display/Hive/Home)

## Sqoop
Apache Sqoop é uma ferramenta projetada para transferir dados entre sistemas de armazenamento de dados estruturados, como bancos de dados relacionais, e o Hadoop. Ele permite a importação e exportação eficiente de grandes volumes de dados, facilitando a integração entre o Hadoop e outras fontes de dados.
- [Laboratório de Sqoop](./hadoop/sqoop/README.MD)
- [Documentação oficial do Sqoop](https://sqoop.apache.org/docs/1.4.7/SqoopUserGuide.html)

## Spark
Apache Spark é uma plataforma de processamento de dados em larga escala que oferece APIs para processamento em lote e em tempo real. Ele é projetado para ser rápido, escalável e fácil de usar, permitindo o processamento eficiente de grandes volumes de dados em clusters. O Spark suporta várias linguagens de programação, incluindo Java, Scala, Python e R.
- [Laboratório de Spark](./hadoop/spark/README.MD)
- [Documentação oficial do Spark](https://spark.apache.org/docs/latest/)

## Kafka
Apache Kafka é uma plataforma de streaming distribuída projetada para processar fluxos de dados em tempo real. Ele é amplamente utilizado para construir pipelines de dados e aplicações de streaming, permitindo a publicação, assinatura e processamento de fluxos de eventos em larga escala. O Kafka é altamente escalável e tolerante a falhas, tornando-o ideal para aplicações que exigem alta disponibilidade e desempenho.
- [Laboratório de Kafka](./hadoop/kafka/README.MD)
- [Documentação oficial do Kafka](https://kafka.apache.org/documentation/)