SELECT
    CAST(admission_type_id AS INT64) AS type_admission_id,
    description,
    categorie
FROM
    {{ source('raw', 'types_admissions') }}