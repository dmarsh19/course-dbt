{{
    config(
        materialized='table'
    )
}}

select
    dp.product_guid,
    name,
    count(distinct doi.order_guid) as num_orders,
    sum(quantity) as quantity_ordered,
    min(created_at_utc) as first_order_at_utc,
    max(created_at_utc) as last_order_at_utc
from
    {{ ref('dim_products') }} as dp
    join {{ ref('dim_order_items') }} doi
        on dp.product_guid = doi.product_guid
    join {{ ref('fct_orders') }} as fo
        on doi.order_guid = fo.order_guid

{{ dbt_utils.group_by(2) }}
