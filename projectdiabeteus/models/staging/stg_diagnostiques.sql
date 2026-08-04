SELECT
    CAST(encounter_id AS INT64) AS hospitalisation_id,
    diag_1 AS icd9_id
FROM
    {{ source('raw', 'diabetic_data') }}
WHERE
    diag_1 != "?"

UNION DISTINCT

SELECT
    CAST(encounter_id AS INT64) AS hospitalisation_id,
    diag_2 AS icd9_id
FROM
    {{ source('raw', 'diabetic_data') }}
WHERE
    diag_2 != "?"

UNION DISTINCT

SELECT
    CAST(encounter_id AS INT64) AS hospitalisation_id,
    diag_3 AS icd9_id
FROM
    {{ source('raw', 'diabetic_data') }}
WHERE
    diag_3 != "?"