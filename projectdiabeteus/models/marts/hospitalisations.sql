{{
    config(
        materialized='table'
    )
}}

SELECT
    hospitalisation_id,
    patient_id,
    type_admission_id,
    sortie_id,
    source_admission_id,
    sm.specialite_id,
    tranche_age,
    duree,
    n_test_lab,
    n_procedure,
    n_medicament,
    n_visite_externe,
    n_visite_urgence,
    n_visite_hopital,
    n_diag,
    insulin,
    n_changement_posologie,
    readmis
FROM
    {{ ref('stg_hospitalisations') }} h
    LEFT JOIN {{ ref('stg_specialites_medicales')}} AS sm ON h.specialite_medecin = sm.specialite