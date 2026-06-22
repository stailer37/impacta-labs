select
    e.employee_id,
    e.first_name || ' ' || e.last_name as employee_name,
    e.title,
    e.region,
    e.manager_id,
    m.first_name || ' ' || m.last_name as manager_name,
    e.hire_date
from {{ ref('stg_employees') }} e
left join {{ ref('stg_employees') }} m on m.employee_id = e.manager_id
