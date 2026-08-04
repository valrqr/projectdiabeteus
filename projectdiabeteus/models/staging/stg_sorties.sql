SELECT
    CAST(discharge_disposition_id AS INT64) AS sortie_id,
    description,
    categorie
FROM
    {{ source('raw', 'sorties') }}