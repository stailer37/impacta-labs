select
    transaction_id || '-' || cast(product_id as varchar) as pos_sales_line_id,
    transaction_id,
    date(event_timestamp) as sale_date,
    event_timestamp,
    store_id,
    register_id,
    customer_id,
    employee_id,
    product_id,
    payment_method,
    quantity,
    cast(unit_price as decimal(10, 2)) as unit_price,
    cast(discount as decimal(4, 3)) as discount,
    cast(round(quantity * unit_price * (1 - discount), 2) as decimal(13, 4)) as line_revenue
from {{ ref('stg_pos_transactions') }}
