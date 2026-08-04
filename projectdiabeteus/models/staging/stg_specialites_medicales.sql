-- models/staging/stg_specialites_medicales.sql

with source as (
    select * from {{ source('raw_diabetic_data', 'Medical_Specialty_Mapping') }}
),

renamed as (

    select
        row_number() over (order by original_speciality) as specialite_id,
        original_speciality as specialite,
        general_category as categorie

    from source

)

select * from renamed