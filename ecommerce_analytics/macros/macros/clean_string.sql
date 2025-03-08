{% macro clean_string(column_name) %}
  TRIM(LOWER(REGEXP_REPLACE({{column_name}}, '[^a-zA-Z0-9]',""))) 
{% endmacro %}