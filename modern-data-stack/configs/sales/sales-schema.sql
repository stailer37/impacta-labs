-- Schema transacional clássico de vendas (clientes, vendedores, produtos, pedidos)
-- usado como fonte para os exercícios de ingestão (NiFi) e transformação (dbt) do lab.

CREATE TABLE customers (
    customer_id   SERIAL PRIMARY KEY,
    customer_name TEXT NOT NULL,
    email         TEXT,
    segment       TEXT NOT NULL,
    city          TEXT NOT NULL,
    region        TEXT NOT NULL,
    country       TEXT NOT NULL,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name  TEXT NOT NULL,
    last_name   TEXT NOT NULL,
    title       TEXT NOT NULL,
    region      TEXT NOT NULL,
    manager_id  INTEGER REFERENCES employees (employee_id),
    hire_date   DATE NOT NULL
);

CREATE TABLE products (
    product_id   SERIAL PRIMARY KEY,
    product_name TEXT NOT NULL,
    category     TEXT NOT NULL,
    unit_price   NUMERIC(10, 2) NOT NULL,
    discontinued BOOLEAN NOT NULL DEFAULT false
);

CREATE TABLE orders (
    order_id    SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers (customer_id),
    employee_id INTEGER NOT NULL REFERENCES employees (employee_id),
    order_date  TIMESTAMPTZ NOT NULL,
    ship_date   TIMESTAMPTZ,
    status      TEXT NOT NULL
);

CREATE TABLE order_items (
    order_id   INTEGER NOT NULL REFERENCES orders (order_id),
    product_id INTEGER NOT NULL REFERENCES products (product_id),
    unit_price NUMERIC(10, 2) NOT NULL,
    quantity   INTEGER NOT NULL,
    discount   NUMERIC(4, 3) NOT NULL DEFAULT 0,
    PRIMARY KEY (order_id, product_id)
);
