-- Base de dados para os laboratórios de Sqoop
USE impacta;

-- Tabela de funcionários (usada nos labs de Sqoop)
CREATE TABLE IF NOT EXISTS employees (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  department  VARCHAR(100),
  role        VARCHAR(100),
  salary      DECIMAL(10, 2),
  hire_date   DATE
);

INSERT INTO employees (name, department, role, salary, hire_date) VALUES
  ('João Silva',       'Engenharia',  'Analista',       4500.00, '2020-01-15'),
  ('Maria Oliveira',   'Gestão',      'Gerente',        8500.00, '2019-06-01'),
  ('Carlos Santos',    'Engenharia',  'Desenvolvedor',  6000.00, '2018-03-20'),
  ('Alice Lima',       'Marketing',   'Analista',       5200.00, '2021-11-10'),
  ('Bruno Costa',      'Engenharia',  'Desenvolvedor',  6800.00, '2020-08-05'),
  ('Fernanda Rocha',   'Financeiro',  'Analista',       5700.00, '2019-03-15'),
  ('Gabriel Nunes',    'Marketing',   'Coordenador',    7200.00, '2020-09-20'),
  ('Helena Ferreira',  'TI',          'Especialista',   8200.00, '2021-01-08'),
  ('Igor Moura',       'Engenharia',  'Arquiteto',      9500.00, '2017-11-30'),
  ('Júlia Pereira',    'Financeiro',  'Gerente',        8800.00, '2022-02-14');

-- Tabela de produtos (segundo dataset para exercícios de Sqoop)
CREATE TABLE IF NOT EXISTS products (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  name      VARCHAR(200) NOT NULL,
  category  VARCHAR(100),
  price     DECIMAL(10, 2),
  stock     INT DEFAULT 0
);

INSERT INTO products (name, category, price, stock) VALUES
  ('Notebook Dell XPS',       'Eletrônicos',   4500.00, 50),
  ('Mouse Sem Fio Logitech',  'Periféricos',    180.00, 200),
  ('Teclado Mecânico',        'Periféricos',    420.00, 100),
  ('Monitor LG 27"',          'Eletrônicos',   1900.00, 30),
  ('Headset Sony',            'Periféricos',    350.00, 75),
  ('Tablet Samsung',          'Eletrônicos',   2200.00, 40),
  ('Webcam Full HD',          'Periféricos',    290.00, 120),
  ('SSD 1TB',                 'Armazenamento', 580.00, 60);

-- Garante que o usuário sqoop tem permissão total no banco impacta
GRANT ALL PRIVILEGES ON impacta.* TO 'sqoop'@'%';
FLUSH PRIVILEGES;
