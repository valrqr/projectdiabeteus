{{ config(materialized='table') }}

select *
from {{ ref('stg_sources_admissions') }}