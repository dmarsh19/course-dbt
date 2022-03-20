SELECT
    product_id as product_guid,
    name,
    price as price_usd,
    inventory
FROM
    {{ source('src_postgres', 'products') }}
