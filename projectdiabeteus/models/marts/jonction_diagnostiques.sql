-- models/marts/bridge_hospitalisation_diagnostics.sql

with unpivoted as (
    select hospitalisation_id, diag_1 as icd9_id from {{ ref('stg_diabetic_data') }}
    union all
    select hospitalisation_id, diag_2 from {{ ref('stg_diabetic_data') }}
    union all
    select hospitalisation_id, diag_3 from {{ ref('stg_diabetic_data') }}
)

select * from unpivoted
where icd9_id  is not null