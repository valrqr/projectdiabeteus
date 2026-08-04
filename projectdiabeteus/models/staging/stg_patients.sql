SELECT
    CAST(patient_nbr AS INT64) AS patient_id,
    CASE 
        WHEN MIN(race) != MAX(race) THEN "?" 
        ELSE MIN(race) 
        END
    AS ethnie,
    CASE 
        WHEN MIN(gender) != MAX(gender) THEN "?" 
        WHEN MIN(gender) NOT IN  ("Female", "Male") THEN "?" 
        ELSE MIN(gender) 
        END
    AS genre
FROM 
    {{ source('raw', 'diabetic_data') }}
GROUP BY 
    patient_nbr
