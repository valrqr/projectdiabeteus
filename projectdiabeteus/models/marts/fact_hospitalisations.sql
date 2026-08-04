-- models/marts/hospitalisations.sql

{{ config(materialized='table') }}

select
    hospitalisation_id,
    patient_id,
    type_admission_id,
    sortie_id,
    specialite_id,
    source_admission_id,
    tranche_age,
    duree,
    n_test_lab,
    n_procedure,
    n_medicament,
    n_visite_externe,
    n_visite_hospitaliere,
    n_visite_urgence,
    n_diagnostic,
    insulin,
    n_changement_traitement_diabete,
    readmis

from {{ ref('int_diabetic_data') }}