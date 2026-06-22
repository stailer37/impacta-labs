select
    f.sales_line_id,
    f.order_id,
    f.order_date,
    f.ship_date,
    f.status,
    c.customer_id,
    c.customer_name,
    c.segment as customer_segment,
    c.region as customer_region,
    c.country as customer_country,
    e.employee_id,
    e.employee_name,
    e.region as employee_region,
    p.product_id,
    p.product_name,
    p.category as product_category,
    f.quantity,
    f.unit_price,
    f.discount,
    f.line_revenue
from {{ ref('fct_sales') }} f
join {{ ref('dim_customer') }} c on c.customer_id = f.customer_id
join {{ ref('dim_employee') }} e on e.employee_id = f.employee_id
join {{ ref('dim_product') }} p on p.product_id = f.product_id
