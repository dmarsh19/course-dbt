{{
    config(
        materialized='table'
    )
}}

with session_length as (
    select
        session_guid,
        min(created_at_utc) as first_event,
        max(created_at_utc) as last_event
    from {{ ref('fct_events') }}
    group by 1
)

select
    int_session_events_agg.session_guid,
    int_session_events_agg.user_guid,
    dim_users.first_name,
    dim_users.last_name,
    int_session_events_agg.page_view,
    int_session_events_agg.add_to_cart,
    int_session_events_agg.checkout,
    int_session_events_agg.package_shipped,
    session_length.first_event as first_session_event,
    session_length.last_event as last_session_event,
    (
        date_part('day', session_length.last_event::timestamp - session_length.first_event::timestamp) * 24 +
        date_part('hour', session_length.last_event::timestamp - session_length.first_event::timestamp) * 60 +
        date_part('minute', session_length.last_event::timestamp - session_length.first_event::timestamp)
    ) as session_length_minutes
from
    {{ ref('int_session_events_agg') }}
    left join {{ ref('dim_users') }}
        on int_session_events_agg.user_guid = dim_users.user_guid
    left join session_length
        on int_session_events_agg.session_guid = session_length.session_guid
