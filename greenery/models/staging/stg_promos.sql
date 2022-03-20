SELECT
    promo_id,
    discount as discount_usd,
    status
FROM
    {{ source('src_postgres', 'promos') }}
