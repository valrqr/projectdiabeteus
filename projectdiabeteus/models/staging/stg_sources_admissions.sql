SELECT
    CAST(admission_source_id AS INT64) AS source_admission_id,
    description,
    categorie
FROM
    {{ source('raw', 'sources_admissions') }}