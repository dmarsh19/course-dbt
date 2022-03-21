{{
    config(
        materialized='table'
    )
}}

with user_orders as (
    select
        user_guid,
        count(distinct fct_orders.order_guid) as num_orders,
        min(created_at_utc) as first_order_at_utc,
        max(created_at_utc) as last_order_at_utc,
        sum(order_cost_usd) as total_cost_usd,
        sum(int_order_items_agg.num_items) as total_num_items
    from {{ ref('fct_orders') }}
        left join {{ ref('int_order_items_agg') }}
            on int_order_items_agg.order_guid = fct_orders.order_guid
    group by 1
)
select
    user_orders.user_guid,
    user_orders.num_orders,
    user_orders.first_order_at_utc,
    user_orders.last_order_at_utc,
    user_orders.total_cost_usd,
    user_orders.total_num_items,
    int_user_address_join.country
from
    user_orders
    left join {{ ref('int_user_address_join') }}
        on int_user_address_join.user_guid = user_orders.user_guid