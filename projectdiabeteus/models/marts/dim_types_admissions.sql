{{ config(materialized='table') }}

select *
from {{ ref('stg_types_admissions') }}