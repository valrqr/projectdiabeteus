--Selection de la source
with source as (
    select * from {{ source('raw_diabetic_data', 'sources_admissions') }}
),

renamed as (

    select
    --- renommage des deux colonnes et forçage du format pour l'id
        cast(admission_source_id as int64) as source_admission_id,
        description as libelle_admission_source

    from source

)

select * from renamed