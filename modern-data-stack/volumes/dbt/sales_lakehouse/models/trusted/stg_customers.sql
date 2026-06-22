select
    customer_id,
    customer_name,
    email,
    segment,
    city,
    region,
    country,
    created_at
from {{ source('raw', 'customers') }}
