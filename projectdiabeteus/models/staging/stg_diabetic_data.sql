-- models/staging/stg_diabetic_data.sql
--- identification des colonnes textuelles pour traitement différencié des colonnes int64
{% set colonnes_texte = [
    ('age', 'tranche_age'),
    ('medical_specialty', 'specialite_medecin'),
    ('examide', 'examide'),
    ('acarbose', 'acarbose'),
    ('miglitol', 'miglitol'),
    ('glipizide', 'glipizide'),
    ('glyburide', 'glyburide'),
    ('metformin', 'metformin'),
    ('tolazamide', 'tolazamide'),
    ('citoglipton', 'citoglipton'),
    ('glimepiride', 'glimepiride'),
    ('nateglinide', 'nateglinide'),
    ('repaglinide', 'repaglinide'),
    ('tolbutamide', 'tolbutamide'),
    ('pioglitazone', 'pioglitazone'),
    ('troglitazone', 'troglitazone'),
    ('acetohexamide', 'acetohexamide'),
    ('rosiglitazone', 'rosiglitazone'),
    ('chlorpropamide', 'chlorpropamide'),
    ('glipizide_metformin', 'glipizide_metformin'),
    ('glyburide_metformin', 'glyburide_metformin'),
    ('metformin_pioglitazone', 'metformin_pioglitazone'),
    ('metformin_rosiglitazone', 'metformin_rosiglitazone'),
    ('glimepiride_pioglitazone', 'glimepiride_pioglitazone'),
    ('insulin', 'insulin'),
    ('diag_1', 'diag_1'),
    ('diag_2', 'diag_2'),
    ('diag_3', 'diag_3'),
    ('max_glu_serum', 'max_glu_serum'),
    ('A1Cresult', 'a1c_result'),
    ('readmitted', 'readmitted'),
    ('change', 'change'),
    ('diabetesMed', 'diabetesMed')
] %}
---- identification de la source
with source as (
    select * from {{ source('raw_diabetic_data', 'diabetic_data') }}
),
renamed as (
    select
        -- Colonnes castées en int64, l'utilisation de safe_cast prévient les erreurs en cas de valeurs manquantes et renvoi NULL
        safe_cast(encounter_id as int64) as hospitalisation_id,
        safe_cast(patient_nbr as int64) as patient_id,
        -- prise en compte de la fusion des id/descriptions dans la table types_admissions et fusion sous un seul ID + remapping
        safe_cast(
            case
                when admission_type_id in ('5', '6', '8') then '5'
                when admission_type_id = '7' then '6'
                else admission_type_id
            end
            as int64
        ) as type_admission_id,
        safe_cast(discharge_disposition_id as int64) as sortie_id,
        -- correction des données cause doublon dans la table raw admission_source (15 et 9 renvoient à la même description)
        safe_cast(
            case
                when admission_source_id = '15' then '9'
                else admission_source_id
            end
            as int64
        ) as source_admission_id,
        safe_cast(time_in_hospital as int64) as duree,
        safe_cast(num_lab_procedures as int64) as n_test_lab,
        safe_cast(num_procedures as int64) as n_procedure,
        safe_cast(num_medications as int64) as n_medicament,
        safe_cast(number_outpatient as int64) as n_visite_externe,
        safe_cast(number_emergency as int64) as n_visite_urgence,
        safe_cast(number_inpatient as int64) as n_visite_hospitaliere,
        safe_cast(number_diagnoses as int64) as n_diagnostic,
        -- pour chaque colonne textuelle, on applique la macro normalisation, on renomme en utilisant l'alias déclaré et on termine avec une ",", le tout dans un loop
        {% for col, alias in colonnes_texte %}
        {{ normalisation_outcasts(col) }} as {{ alias }},
        {% endfor %}

        --transformations/traitement des valeurs nulles, ?, etc...
--- cas ethnie : si ? ou plusieurs ethnies différentes enregistrées pour un même patient
    case
        when count(distinct race) over (partition by patient_nbr) > 1 then '?'
        else race
    end as ethnie,


--- cas identique pour le genre, si deux genres connus pour un même patient 
    case
        when count(distinct gender) over (partition by patient_nbr) > 1 then '?'
        else gender
    end as genre

    from source
)




select * from renamed




