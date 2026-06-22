"""
Roda o projeto dbt do sales_lakehouse uma vez por dia: trusted (staging) primeiro,
depois refined (marts/data products).

Pré-requisitos que precisam existir ANTES da primeira execução desta DAG (ver README):
- raw.sales_db.* (tabelas Iceberg) carregadas via Trino CTAS a partir do sales_db —
  seção "Carga da Camada Raw".
- raw.streaming.pos_transactions criada pelo serviço spark_streaming (basta ele já ter
  rodado uma vez) — seção "Streaming de Dados com Kafka e Spark Structured Streaming".
  `stg_pos_transactions`/`fct_pos_sales`/`sales_omnichannel` leem dessa tabela; se ela
  não existir, `dbt_run_trusted`/`dbt_run_refined` falham com ICEBERG_CATALOG_ERROR.

Sem isso, a DAG fica vermelha de propósito: ela representa o pipeline completo
(trusted -> refined) na ordem certa, em vez de pular a dependência real só para ficar
verde.
"""

from datetime import datetime

from airflow import DAG
from airflow.operators.bash import BashOperator

DBT_PROJECT_DIR = "/opt/dbt/sales_lakehouse"
DBT_RUN = f"dbt run --project-dir {DBT_PROJECT_DIR}"
DBT_TEST = f"dbt test --project-dir {DBT_PROJECT_DIR}"

with DAG(
    dag_id="sales_lakehouse_dbt",
    description="Constroi as camadas trusted e refined do sales_lakehouse via dbt-trino.",
    schedule="@daily",
    start_date=datetime(2026, 1, 1),
    catchup=False,
    tags=["dbt", "sales_lakehouse"],
) as dag:

    run_trusted = BashOperator(
        task_id="dbt_run_trusted",
        bash_command=f"{DBT_RUN} --select trusted",
    )

    test_trusted = BashOperator(
        task_id="dbt_test_trusted",
        bash_command=f"{DBT_TEST} --select trusted",
    )

    run_refined = BashOperator(
        task_id="dbt_run_refined",
        bash_command=f"{DBT_RUN} --select refined",
    )

    test_refined = BashOperator(
        task_id="dbt_test_refined",
        bash_command=f"{DBT_TEST} --select refined",
    )

    run_trusted >> test_trusted >> run_refined >> test_refined
