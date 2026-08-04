--Selection de la source
with source as (
    select * from {{ source('raw_diabetic_data', 'sorties') }}
),

renamed as (

    select
    --- renommage des deux colonnes et forçage du format pour l'id
        cast(discharge_disposition_id as int64) as sortie_id,
        description as libelle_sortie

    from source

)

select * from renamed