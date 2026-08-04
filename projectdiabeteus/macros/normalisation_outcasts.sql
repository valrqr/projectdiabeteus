{% macro normalisation_outcasts(column_name) %}
    case
        when {{ column_name }} is null then '?'
        when trim({{ column_name }}) = '' then '?'
        when upper(trim({{ column_name }})) = 'NULL' then '?'
        else {{ column_name }}
    end
{% endmacro %}