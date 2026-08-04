{{
    config(
        materialized='table'
    )
}}

SELECT
    *
FROM
    {{ ref('stg_types_admissions') }}