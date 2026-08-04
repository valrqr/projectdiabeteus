{{
    config(
        materialized='table'
    )
}}

SELECT
    *
FROM
    {{ ref('stg_sources_admissions') }}