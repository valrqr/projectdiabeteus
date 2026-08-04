{{
    config(
        materialized='table'
    )
}}

SELECT
    *
FROM
    {{ ref('stg_specialites_medicales') }}