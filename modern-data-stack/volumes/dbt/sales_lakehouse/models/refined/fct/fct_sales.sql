select
    cast(oi.order_id as varchar) || '-' || cast(oi.product_id as varchar) as sales_line_id,
    oi.order_id,
    oi.product_id,
    o.customer_id,
    o.employee_id,
    date(o.order_date) as order_date,
    date(o.ship_date) as ship_date,
    o.status,
    oi.quantity,
    oi.unit_price,
    oi.discount,
    round(oi.quantity * oi.unit_price * (1 - oi.discount), 2) as line_revenue
from {{ ref('stg_order_items') }} oi
join {{ ref('stg_orders') }} o on o.order_id = oi.order_id
