{{
    config(
        materialized='table'
    )
}}

select
    order_guid,
    sum(quantity) as num_items
from
    {{ ref('dim_order_items') }}
group by 1
