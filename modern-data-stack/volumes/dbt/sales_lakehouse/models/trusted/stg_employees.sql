select
    employee_id,
    first_name,
    last_name,
    title,
    region,
    manager_id,
    hire_date
from {{ source('raw', 'employees') }}
