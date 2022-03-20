{{
    config(
        materialized='view'
    )
}}

SELECT
    event_id as event_guid,
    session_id as session_guid,
    user_id as user_guid,
    event_type,
    page_url,
    created_at as created_at_utc
FROM
    {{ source('src_postgres', 'events') }}
