SELECT
    address_id as address_guid,
    address,
    zipcode,
    state,
    country
FROM
    {{ source('src_postgres', 'addresses') }}
