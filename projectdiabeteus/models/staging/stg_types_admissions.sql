--Selection de la source
with source as (
    select * from {{ source('raw_diabetic_data', 'types_admissions') }}
),

renamed as (

    select distinct
    --- fusions des id et descriptions similaires sous le même id 5 et remapping de la table pour avoir une série logique d'id de 1 à 6 
        case
            when admission_type_id in (5, 6, 8) then 5
            when admission_type_id = 7 then 6
            else admission_type_id
        end as type_admission_id,

        case
            when description in ('Not Available', 'NULL', 'Not Mapped') then 'Unknown'
            else description
        end as libelle_admission_type

    from source

)

select * from renamed