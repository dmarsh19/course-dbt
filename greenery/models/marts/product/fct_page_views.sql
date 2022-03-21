{{
    config(
        materialized='table'
    )
}}

select
    page_url,
    count(*) as total_views,
    count(distinct user_guid) as unique_users,
    count(distinct session_guid) as unique_sessions,
    min(created_at_utc) as first_view_at_utc,
    max(created_at_utc) as last_view_at_utc
from
    {{ ref('fct_events') }}
where
    event_type = 'page_view'
group by 1
