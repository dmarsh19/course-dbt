{{
    config(
        materialized='table'
    )
}}

select
    user_guid,
    dim_users.address_guid,
    address,
    zipcode,
    state,
    country
from
    {{ ref('dim_users') }}
    left join {{ ref('dim_addresses') }}
        on dim_users.address_guid = dim_addresses.address_guid
