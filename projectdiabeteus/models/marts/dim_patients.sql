-- models/marts/dim_patients.sql

{{ config(materialized='table') }}

select distinct
    patient_id,
    ethnie,
    genre

from {{ ref('stg_diabetic_data') }}