-- Dados sintéticos para o schema de vendas: ~12 vendedores, ~50 clientes,
-- ~60 produtos em 6 categorias e ~3000 pedidos com 1-4 itens cada.

-- Vendedores (3 gerentes sem manager_id + 9 reps reportando a um gerente)
INSERT INTO employees (first_name, last_name, title, region, manager_id, hire_date) VALUES
    ('Ana', 'Carvalho', 'Sales Manager', 'Sudeste', NULL, '2018-02-01'),
    ('Bruno', 'Lima', 'Sales Manager', 'Sul', NULL, '2018-05-15'),
    ('Carla', 'Mendes', 'Sales Manager', 'Nordeste', NULL, '2019-01-10');

INSERT INTO employees (first_name, last_name, title, region, manager_id, hire_date) VALUES
    ('Diego', 'Santos', 'Sales Rep', 'Sudeste', 1, '2020-03-01'),
    ('Elisa', 'Rocha', 'Sales Rep', 'Sudeste', 1, '2020-07-20'),
    ('Felipe', 'Costa', 'Sales Rep', 'Sul', 2, '2020-09-12'),
    ('Gabriela', 'Alves', 'Sales Rep', 'Sul', 2, '2021-01-05'),
    ('Henrique', 'Dias', 'Sales Rep', 'Nordeste', 3, '2021-04-18'),
    ('Isabela', 'Ramos', 'Sales Rep', 'Nordeste', 3, '2021-08-30'),
    ('João', 'Pereira', 'Sales Rep', 'Centro-Oeste', 1, '2022-02-14'),
    ('Karina', 'Souza', 'Sales Rep', 'Norte', 2, '2022-06-01'),
    ('Leonardo', 'Tavares', 'Sales Rep', 'Centro-Oeste', 3, '2022-11-21');

-- Produtos: 10 por categoria, 6 categorias
INSERT INTO products (product_name, category, unit_price, discontinued)
SELECT
    base.name,
    base.category,
    round((random() * 190 + 10)::numeric, 2) AS unit_price,
    (random() < 0.05) AS discontinued
FROM (
    SELECT unnest(ARRAY['Headphones', 'Monitor', 'Keyboard', 'Mouse', 'Webcam', 'Tablet', 'Speaker', 'Charger', 'Router', 'SSD Drive']) AS name,
           'Electronics' AS category
    UNION ALL
    SELECT unnest(ARRAY['Office Chair', 'Standing Desk', 'Bookshelf', 'Filing Cabinet', 'Desk Lamp', 'Sofa', 'Coffee Table', 'Wardrobe', 'Bed Frame', 'Stool']),
           'Furniture'
    UNION ALL
    SELECT unnest(ARRAY['Notebook', 'Stapler', 'Printer Paper', 'Pen Set', 'Whiteboard', 'Binder', 'Sticky Notes', 'Scissors', 'Envelope Pack', 'Marker Set']),
           'Office Supplies'
    UNION ALL
    SELECT unnest(ARRAY['T-Shirt', 'Hoodie', 'Jacket', 'Cap', 'Socks Pack', 'Jeans', 'Sneakers', 'Backpack', 'Scarf', 'Gloves']),
           'Apparel'
    UNION ALL
    SELECT unnest(ARRAY['Coffee Beans', 'Tea Box', 'Snack Pack', 'Sparkling Water', 'Energy Bar', 'Juice Bottle', 'Granola', 'Chocolate Box', 'Spice Set', 'Honey Jar']),
           'Food & Beverage'
    UNION ALL
    SELECT unnest(ARRAY['Building Blocks', 'Puzzle', 'Board Game', 'Action Figure', 'Remote Car', 'Plush Bear', 'Drone Mini', 'Card Game', 'Art Kit', 'Yo-Yo']),
           'Toys'
) base;

-- Clientes: nomes e cidades brasileiras sorteadas aleatoriamente
INSERT INTO customers (customer_name, email, segment, city, region, country, created_at)
SELECT
    t.first_name || ' ' || t.last_name,
    lower(t.first_name || '.' || t.last_name) || '@example.com',
    t.segment,
    t.city,
    t.region,
    t.country,
    timestamp '2023-01-01' + (random() * 700) * interval '1 day'
FROM (
    SELECT
        (ARRAY['Ana', 'Bruno', 'Carla', 'Diego', 'Elisa', 'Felipe', 'Gabriela', 'Henrique', 'Isabela', 'João',
               'Karina', 'Leonardo', 'Mariana', 'Nicolas', 'Olivia', 'Paulo', 'Quenia', 'Rafael', 'Sofia', 'Tiago',
               'Ursula', 'Vinicius', 'Wesley', 'Ximena', 'Yara', 'Zeca'])[(floor(random() * 26) + 1)::int] AS first_name,
        (ARRAY['Silva', 'Souza', 'Costa', 'Pereira', 'Lima', 'Carvalho', 'Ferreira', 'Rodrigues', 'Almeida',
               'Nascimento', 'Araujo', 'Ribeiro', 'Martins', 'Barbosa', 'Rocha', 'Dias', 'Monteiro', 'Cardoso',
               'Teixeira', 'Moreira'])[(floor(random() * 20) + 1)::int] AS last_name,
        (ARRAY['Consumer', 'Corporate', 'Home Office'])[(floor(random() * 3) + 1)::int] AS segment,
        city.city,
        city.region,
        city.country
    FROM generate_series(1, 50) AS gs
    CROSS JOIN LATERAL (
        SELECT * FROM (VALUES
            ('São Paulo', 'Sudeste', 'Brasil'),
            ('Rio de Janeiro', 'Sudeste', 'Brasil'),
            ('Belo Horizonte', 'Sudeste', 'Brasil'),
            ('Curitiba', 'Sul', 'Brasil'),
            ('Porto Alegre', 'Sul', 'Brasil'),
            ('Salvador', 'Nordeste', 'Brasil'),
            ('Recife', 'Nordeste', 'Brasil'),
            ('Brasília', 'Centro-Oeste', 'Brasil'),
            ('Fortaleza', 'Nordeste', 'Brasil'),
            ('Manaus', 'Norte', 'Brasil')
        ) AS c(city, region, country)
        ORDER BY random()
        LIMIT 1
    ) city
) t;

-- Pedidos: ~3000 pedidos espalhados entre 1 mês atrás e a data atual,
-- pra ficar coerente com a janela de dados gerada pelo streaming.
INSERT INTO orders (customer_id, employee_id, order_date, ship_date, status)
SELECT
    (floor(random() * 50) + 1)::int AS customer_id,
    (floor(random() * 12) + 1)::int AS employee_id,
    s.order_date,
    CASE WHEN s.status = 'completed' THEN s.order_date + (floor(random() * 5) + 1) * interval '1 day' ELSE NULL END AS ship_date,
    s.status
FROM (
    SELECT
        current_date::timestamp - (random() * interval '1 month') AS order_date,
        (ARRAY['completed', 'completed', 'completed', 'completed', 'pending', 'cancelled'])[(floor(random() * 6) + 1)::int] AS status
    FROM generate_series(1, 3000)
) s;

-- Itens de pedido: 1 a 4 produtos distintos por pedido.
-- O número de itens é calculado na query externa (o.n_items) e passado pro LIMIT da
-- LATERAL: se o random() ficasse só dentro do LIMIT, sem referenciar a linha externa,
-- o planner do Postgres avalia a expressão uma única vez e reaproveita pra todo mundo
-- (todo pedido acabaria com a mesma quantidade de itens).
INSERT INTO order_items (order_id, product_id, unit_price, quantity, discount)
SELECT
    o.order_id,
    p.product_id,
    p.unit_price,
    (floor(random() * 5) + 1)::int AS quantity,
    (ARRAY[0, 0, 0, 0.05, 0.1, 0.15])[(floor(random() * 6) + 1)::int]::numeric(4, 3) AS discount
FROM (
    SELECT order_id, (floor(random() * 4) + 1)::int AS n_items
    FROM orders
) o
CROSS JOIN LATERAL (
    SELECT product_id, unit_price
    FROM products
    ORDER BY random()
    LIMIT o.n_items
) p;
