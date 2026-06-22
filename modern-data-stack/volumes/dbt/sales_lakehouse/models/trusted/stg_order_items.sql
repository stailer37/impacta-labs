select
    order_id,
    product_id,
    unit_price,
    quantity,
    discount
from {{ source('raw', 'order_items') }}
