SELECT
    order_id as order_guid,
    promo_id,
    user_id as user_guid,
    address_id as address_guid,
    created_at as created_at_utc,
    order_cost as order_cost_usd,
    shipping_cost as shipping_cost_usd,
    order_total as order_total_usd,
    tracking_id as tracking_guid,
    shipping_service,
    estimated_delivery_at as estimated_delivery_at_utc,
    delivered_at as delivered_at_utc,
    status
FROM
    {{ source('src_postgres', 'orders') }}
