SELECT
    Diagnostic_Code AS icd9_id,
    Description AS description,
    Category AS categorie
FROM
    {{ source('raw', 'Diagnostic_Codes') }}