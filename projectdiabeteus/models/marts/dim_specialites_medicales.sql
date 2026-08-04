-- models/marts/dim_specialites_medicales.sql

{{ config(materialized='table') }}

select *
from {{ ref('stg_specialites_medicales') }}