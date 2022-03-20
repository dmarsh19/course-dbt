SELECT
    order_id as order_guid,
    product_id as product_guid,
    quantity
FROM
    {{ source('src_postgres', 'order_items') }}
