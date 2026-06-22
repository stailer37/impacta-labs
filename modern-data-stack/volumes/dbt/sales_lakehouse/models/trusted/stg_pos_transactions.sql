select
    transaction_id,
    event_timestamp,
    store_id,
    register_id,
    employee_id,
    customer_id,
    product_id,
    quantity,
    unit_price,
    discount,
    payment_method
from {{ source('raw_streaming', 'pos_transactions') }}
