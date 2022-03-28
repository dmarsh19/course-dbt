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
    product_guid,
    name
    {% for event_type in event_types['event_type'] %}
        , sum(case when event_type = {{ event_type }} then 1 else 0 end) as {{ event_types['column_name'][loop.index0] }}
    {% endfor %}
from
    {{ ref('fct_events') }} as fe
    join {{ ref('dim_products') }} dp
        on (string_to_array(fe.page_url, '/'))[5] = dp.product_guid

{{ dbt_utils.group_by(2) }}
