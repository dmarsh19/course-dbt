{{
    config(
        materialized='table'
    )
}}

SELECT
    product_guid,
    name,
    price_usd,
    inventory
FROM
    {{ ref('stg_products') }}
