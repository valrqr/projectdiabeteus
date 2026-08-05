from google.cloud import bigquery

####################################################
# -- Récupération des données depuis BigQuery   -- #
####################################################
client = bigquery.Client(project='projectdiabeteus')

f_query = "SELECT * FROM `projectdiabeteus.dbt_shared.{}`"
d_df = {}
for table in ["patients", "hospitalisations", "icd9", "diagnostiques", "sorties", "sources_admissions", "specialites_medicales", "types_admissions"]:
    d_df[table] = client.query(f_query.format(table)).to_dataframe()

####################################################
# -- Création d'un DataFrame unique             -- #
####################################################
d_diag = d_df["diagnostiques"].merge(d_df["icd9"], on="icd9_id", how="left")
d_diag["count"] = d_diag.groupby("hospitalisation_id").cumcount() + 1
d_diag = d_diag.pivot(index='hospitalisation_id', columns='count', values=['description', 'categorie']).reset_index()
d_diag.columns.name = None
d_diag.columns = [f"{e[0]}_{e[1]}" if e[1] != '' else e[0] for e in d_diag.columns.to_flat_index()]


df = (d_df["hospitalisations"]
    .merge(d_df["patients"], on="patient_id", how="left")
    .merge(d_df["sorties"], on="sortie_id", how="left", suffixes=("", "_sortie"))
    .merge(d_df["sources_admissions"], on="source_admission_id", how="left", suffixes=("", "_source_admission"))
    .merge(d_df["specialites_medicales"], on="specialite_id", how="left", suffixes=("", "_specialite"))
    .merge(d_df["types_admissions"], on="type_admission_id", how="left", suffixes=("", "_type_admission"))
    .merge(d_diag, on="hospitalisation_id", how="left")
    .rename({"description": "description_sortie", "categorie": "categorie_sortie"}, axis=1)
    .fillna("?"))

####################################################
# -- Sauvegarde du DataFrame final              -- #
####################################################
df.to_csv("/root/Trainings/La Capsule/Projet final/dbt/projectdiabeteus/machine_learning/data/diabetes.csv", index=False)
