# Introdução
O Sqoop é uma ferramenta projetada para transferir dados entre sistemas de armazenamento de dados estruturados, como bancos de dados relacionais, e o Hadoop. Ele permite a importação e exportação de dados entre o Hadoop e bancos de dados como MySQL, PostgreSQL, Oracle, entre outros.

## Objetivo

Neste exercício, você irá realizar a extração de dados de uma base MySQL utilizando o Sqoop na máquina virtual Cloudera.

### Tempo estimado

:hourglass_flowing_sand: 15 minutos

### Roteiro de atividades
- **A)** Configurar a base de dados MySQL
- **B)** Verificar a conexão com o MySQL
- **C)** Executar o Sqoop para extração de dados
- **D)** Verificar os dados no HDFS
- **E)** Limpeza (opcional)
- **F)** Desafio

---

# Atividades

## Iniciar a VM

> Para importar a máquina virtual no [VirtualBox](https://www.virtualbox.org/wiki/Downloads) é necessário instalar também o pacote de extensão.
- Após instalar o VirtualBox, basta selecionar e clicar duas vezes no arquivo `cloudera-quickstart-vm-5.13.0-0-virtualbox.ovf`.
  - O processo de importação pode demorar alguns minutos, pois a máquina virtual é grande (cerca de 5 GB).

- Antes de inicializar a máquina virtual, certifique-se de ter habilitado a opção de rede `Bridged Adapter` para que a máquina virtual tenha acesso à internet e possa ser acessada pela sua máquina.
  - Clique com o botão direito do mouse na máquina virtual e selecione `Configurações` > `Rede` > `Adaptador 1` > `Conectado a` > `Placa em modo Bridge`.

- Clique em `OK` para salvar as alteraçõe e inicie a máquina virtual clicando com o botão direito do mouse e selecionando `Iniciar`.

## A) Configurar a Base de Dados MySQL

1. Acesse o MySQL:
    ```bash
    mysql -u cloudera -p
    ```

2. Crie uma base de dados de `impacta`:
    ```sql
    CREATE DATABASE impacta;
    ```

3. Use a base de dados criada:
    ```sql
    USE impacta;
    ```

4. Crie uma tabela e insira dados:
    ```sql
    CREATE TABLE employees (
         id INT AUTO_INCREMENT PRIMARY KEY,
         name VARCHAR(100),
         role VARCHAR(50),
         salary DECIMAL(10, 2)
    );

    INSERT INTO employees (name, role, salary) VALUES
    ('João Silva', 'Analista', 4500.00),
    ('Maria Oliveira', 'Gerente', 8500.00),
    ('Carlos Santos', 'Desenvolvedor', 6000.00);
    ```

## B) Verificar Conexão com o MySQL

Certifique-se de que o MySQL está acessível pela máquina virtual. Teste a conexão com o comando:
```bash
mysql -u cloudera -p -h cloudera
```

## C) Executar o Sqoop para Extração de Dados

1. Liste os bancos de dados disponíveis no MySQL:
    ```bash
    sqoop list-databases \
    --connect jdbc:mysql://localhost:3306/ \
    --username cloudera -P
    ```

2. Liste as tabelas no banco de dados `impacta`:
    ```bash
    sqoop list-tables \
    --connect jdbc:mysql://localhost:3306/impacta \
    --username cloudera -P
    ```

3. Extraia os dados da tabela `employees` para o HDFS:
    ```bash
    sqoop import \
    --connect jdbc:mysql://localhost:3306/exemplo \
    --username root -P \
    --table employees \
    --target-dir /user/cloudera/employees \
    --m 1
    ```

## D) Verificar os Dados no HDFS

Após a execução do comando, verifique se os dados foram importados corretamente para o HDFS:
```bash
hdfs dfs -ls /user/cloudera/employees
hdfs dfs -cat /user/cloudera/employees/part-m-00000
```

## E) Limpeza (Opcional)

Se desejar, remova os dados importados do HDFS:
```bash
hdfs dfs -rm -r /user/cloudera/employees
```

## Desafio
- Tente importar dados de maneira incremental, utilizando a opção `--incremental` do Sqoop.
> [!TIP]
> **Dica:** [Consulte a documentação](https://sqoop.apache.org/docs/1.4.7/SqoopUserGuide.html#_incremental_imports) do Sqoop para entender como funciona a importação incremental e como configurar o Sqoop para isso.
- Explore as opções de exportação do Sqoop para enviar dados de volta ao MySQL.
> [!TIP]
> **Dica:** [Consulte a documentação](https://sqoop.apache.org/docs/1.4.7/SqoopUserGuide.html#_literal_sqoop_export_literal) do Sqoop para entender como funciona a exportação e como configurar o Sqoop para isso.
