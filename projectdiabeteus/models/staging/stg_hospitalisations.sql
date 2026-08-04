SELECT 
    CAST(encounter_id AS INT64) AS hospitalisation_id,
    CAST(patient_nbr AS INT64) AS patient_id,
    CAST(admission_type_id AS INT64) AS type_admission_id,
    CAST(discharge_disposition_id AS INT64) AS sortie_id,
    CASE
        WHEN admission_source_id = '15' THEN 9
        ELSE CAST(admission_source_id AS INT64)
    END
    AS source_admission_id,
    age AS tranche_age,
    CAST(time_in_hospital AS INT64) AS duree,
    medical_specialty AS specialite_medecin,
    CAST(num_lab_procedures AS INT64) AS n_test_lab,
    CAST(num_procedures AS INT64) AS n_procedure,
    CAST(num_medications AS INT64) AS n_medicament,
    CAST(number_outpatient AS INT64) AS n_visite_externe,
    CAST(number_emergency AS INT64) AS n_visite_urgence,
    CAST(number_inpatient AS INT64) AS n_visite_hopital,
    CAST(number_diagnoses AS INT64) AS n_diag,
    insulin,
    {{ convert_med_to_binary('metformin') }} 
        + {{ convert_med_to_binary('repaglinide') }}
        + {{ convert_med_to_binary('nateglinide') }}
        + {{ convert_med_to_binary('chlorpropamide') }}
        + {{ convert_med_to_binary('glimepiride') }}
        + {{ convert_med_to_binary('acetohexamide') }}
        + {{ convert_med_to_binary('glipizide') }}
        + {{ convert_med_to_binary('glyburide') }}
        + {{ convert_med_to_binary('tolbutamide') }}
        + {{ convert_med_to_binary('pioglitazone') }}
        + {{ convert_med_to_binary('rosiglitazone') }}
        + {{ convert_med_to_binary('acarbose') }}
        + {{ convert_med_to_binary('miglitol') }}
        + {{ convert_med_to_binary('troglitazone') }}
        + {{ convert_med_to_binary('tolazamide') }}
        + {{ convert_med_to_binary('examide') }}
        + {{ convert_med_to_binary('insulin') }}
        + {{ convert_med_to_binary('glyburide_metformin') }} 
        + {{ convert_med_to_binary('glipizide_metformin') }} 
        + {{ convert_med_to_binary('glimepiride_pioglitazone') }} 
        + {{ convert_med_to_binary('metformin_rosiglitazone') }} 
        + {{ convert_med_to_binary('metformin_pioglitazone') }} 
    AS n_changement_posologie,
    CASE WHEN readmitted = "<30" THEN 1 ELSE 0 END AS readmis
FROM 
    {{ source('raw', 'diabetic_data') }}
