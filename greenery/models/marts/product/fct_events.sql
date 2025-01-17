{{
    config(
        materialized='table'
    )
}}

SELECT
    event_guid,
    session_guid,
    user_guid,
    event_type,
    page_url,
    created_at_utc,
    order_guid,
    product_guid
FROM
    {{ ref('stg_events') }}
