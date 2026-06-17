-- Base de dados de origem para o ETL do Spark
SET NAMES utf8mb4;
CREATE DATABASE IF NOT EXISTS impacta;
USE impacta;

CREATE TABLE IF NOT EXISTS employees (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  department  VARCHAR(100),
  role        VARCHAR(100),
  salary      DECIMAL(10, 2),
  hire_date   DATE
);

INSERT INTO employees (name, department, role, salary, hire_date) VALUES
  ('João Silva',       'Engenharia', 'Analista',      4500.00, '2020-01-15'),
  ('Maria Oliveira',   'Gestão',     'Gerente',       8500.00, '2019-06-01'),
  ('Carlos Santos',    'Engenharia', 'Desenvolvedor', 6000.00, '2018-03-20'),
  ('Alice Lima',       'Marketing',  'Analista',      5200.00, '2021-11-10'),
  ('Bruno Costa',      'Engenharia', 'Desenvolvedor', 6800.00, '2020-08-05'),
  ('Fernanda Rocha',   'Financeiro', 'Analista',      5700.00, '2019-03-15'),
  ('Gabriel Nunes',    'Marketing',  'Coordenador',   7200.00, '2020-09-20'),
  ('Helena Ferreira',  'TI',         'Especialista',  8200.00, '2021-01-08'),
  ('Igor Moura',       'Engenharia', 'Arquiteto',     9500.00, '2017-11-30'),
  ('Júlia Pereira',    'Financeiro', 'Gerente',       8800.00, '2022-02-14');

CREATE USER IF NOT EXISTS 'spark'@'%' IDENTIFIED BY 'spark123';
GRANT ALL PRIVILEGES ON impacta.* TO 'spark'@'%';
FLUSH PRIVILEGES;
