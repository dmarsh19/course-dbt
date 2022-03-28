{{
    config(
        materialized='table'
    )
}}

{%
    set event_types = dbt_utils.get_query_results_as_dict(
        "select distinct quote_literal(event_type) as event_type, event_type as column_name from"
        ~ ref('fct_events')
    )
%}

select
    session_guid,
    coalesce(fe.product_guid, doi.product_guid) as product_guid
    {% for event_type in event_types['event_type'] %}
        , sum(case when event_type = {{ event_type }} then 1 else 0 end) as {{ event_types['column_name'][loop.index0] }}
    {% endfor %}
from
    {{ ref('fct_events') }} as fe
    full outer join {{ ref('dim_order_items') }} as doi
        on fe.order_guid = doi.order_guid

{{ dbt_utils.group_by(2) }}
