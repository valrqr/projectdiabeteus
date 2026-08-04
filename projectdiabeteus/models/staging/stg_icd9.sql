-- models/staging/stg_icd9.sql

with source as (
    select * from {{ source('raw_diabetic_data', 'Diagnostic_Codes') }}
),

renamed as (

    select
        Diagnostic_Code as icd9_id,
        Description as description,
        Category as categorie

    from source

)

select * from renamed