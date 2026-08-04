SELECT
    ROW_NUMBER() OVER () AS specialite_id,
    original_speciality AS specialite,
    general_category AS categorie
FROM
    {{ source('raw', 'Medical_Specialty_Mapping') }}