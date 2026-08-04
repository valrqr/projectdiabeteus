{% macro convert_med_to_binary(column) %}
  CASE WHEN {{ column }} IN ('Up', 'Down') THEN 1 ELSE 0 END
{% endmacro %}