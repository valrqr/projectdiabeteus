FROM apache/airflow:3.3.0
RUN pip install --no-cache-dir dbt-bigquery apache-airflow-providers-airbyte
