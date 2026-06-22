select
    product_id,
    product_name,
    category,
    unit_price,
    discontinued
from {{ source('raw', 'products') }}
