select
    customer_id,
    customer_name,
    email,
    segment,
    city,
    region,
    country,
    date(created_at) as customer_since
from {{ ref('stg_customers') }}
