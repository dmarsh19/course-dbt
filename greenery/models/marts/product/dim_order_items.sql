{{
    config(
        materialized='table'
    )
}}

SELECT
    order_guid,
    product_guid,
    quantity
FROM
    {{ ref('stg_order_items') }}
