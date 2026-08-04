from airflow.decorators import dag
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator
from airflow.operators.bash import BashOperator
from datetime import datetime

DBT_PROJECT_DIR = "/opt/dbt/projectdiabeteus"
DBT_PROFILES_DIR = "/opt/dbt/projectdiabeteus"

@dag(
    dag_id="pipeline_diabete",
    schedule=None,          # déclenchement manuel pour commencer
    start_date=datetime(2026, 1, 1),
    catchup=False,
    tags=["diabete", "dbt", "airbyte"],
)
def pipeline_diabete():

    sync_airbyte = AirbyteTriggerSyncOperator(
        task_id="airbyte_sync_diabetic_data",
        airbyte_conn_id="airbyte_diabete",   
        connection_id="3c98e73b-db54-490f-ab23-75bd2490f7a8",   # trouvé dans l'URL Airbyte
        asynchronous=False,
        timeout=3600,
        wait_seconds=10,
    )

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=(
            f"cd {DBT_PROJECT_DIR} && "
            f"dbt run --profiles-dir {DBT_PROFILES_DIR}"
        ),
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=(
            f"cd {DBT_PROJECT_DIR} && "
            f"dbt test --profiles-dir {DBT_PROFILES_DIR}"
        ),
    )

    sync_airbyte >> dbt_run >> dbt_test

pipeline_diabete()