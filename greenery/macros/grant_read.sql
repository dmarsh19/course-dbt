
{% macro grant_read(role) %}

  {% set sql %}
    grant select on {{ this }} to {{ role }};
  {% endset %}

  {% set table = run_query(sql) %}

{% endmacro %}
