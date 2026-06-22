with bounds as (
    select
        date(min(order_date)) as min_date,
        date(max(order_date)) as max_date
    from {{ ref('stg_orders') }}
)
select
    d as date_day,
    year(d) as year,
    quarter(d) as quarter,
    month(d) as month,
    day(d) as day_of_month,
    day_of_week(d) as day_of_week,
    day_of_week(d) in (6, 7) as is_weekend
from bounds
cross join unnest(sequence(min_date, max_date, interval '1' day)) as t(d)
