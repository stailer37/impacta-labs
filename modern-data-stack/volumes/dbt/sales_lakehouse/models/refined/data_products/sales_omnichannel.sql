select
    'online-' || f.sales_line_id as sales_line_id,
    'online' as channel,
    f.order_date as sale_date,
    cast(null as varchar) as store_id,
    f.customer_id,
    c.customer_name,
    c.segment as customer_segment,
    c.region as customer_region,
    f.employee_id,
    e.employee_name,
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

union all

select
    'in_store-' || s.pos_sales_line_id as sales_line_id,
    'in_store' as channel,
    s.sale_date,
    s.store_id,
    s.customer_id,
    c.customer_name,
    c.segment as customer_segment,
    c.region as customer_region,
    s.employee_id,
    e.employee_name,
    p.product_id,
    p.product_name,
    p.category as product_category,
    s.quantity,
    s.unit_price,
    s.discount,
    s.line_revenue
from {{ ref('fct_pos_sales') }} s
left join {{ ref('dim_customer') }} c on c.customer_id = s.customer_id
join {{ ref('dim_employee') }} e on e.employee_id = s.employee_id
join {{ ref('dim_product') }} p on p.product_id = s.product_id
