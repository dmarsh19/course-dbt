{{
    config(
        materialized='table'
    )
}}

SELECT
    order_guid,
    promo_id,
    user_guid,
    address_guid,
    created_at_utc,
    order_cost_usd,
    shipping_cost_usd,
    order_total_usd,
    tracking_guid,
    shipping_service,
    estimated_delivery_at_utc,
    delivered_at_utc,
    status
FROM
    {{ ref('stg_orders') }}
