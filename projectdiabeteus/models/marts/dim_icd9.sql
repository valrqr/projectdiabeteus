-- models/marts/dim_diagnostic_codes.sql

{{ config(materialized='table') }}

select *
from {{ ref('stg_icd9') }}