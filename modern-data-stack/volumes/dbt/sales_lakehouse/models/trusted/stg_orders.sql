select
    order_id,
    customer_id,
    employee_id,
    order_date,
    ship_date,
    status
from {{ source('raw', 'orders') }}
