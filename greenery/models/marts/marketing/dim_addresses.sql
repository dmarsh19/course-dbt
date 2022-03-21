{{
    config(
        materialized='table'
    )
}}

SELECT
    address_guid,
    address,
    zipcode,
    state,
    country
FROM
    {{ ref('stg_addresses') }}
