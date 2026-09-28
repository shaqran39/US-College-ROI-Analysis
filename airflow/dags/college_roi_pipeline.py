# Import Python's datetime, used to give the DAG a start date
from datetime import datetime
# Import DAG, the core Airflow class that represents "a pipeline"
from airflow import DAG
# Import BashOperator, a task type that runs a shell command
from airflow.operators.bash import BashOperator
# Import PythonOperator, a task type that runs a Python function
from airflow.operators.python import PythonOperator
# Import os, used here to check whether a file exists and its size
import os

# Store the dbt project's path inside the container in one variable,
# so we don't repeat this long string in every task below
DBT_PROJECT_DIR = "/opt/airflow/dbt_shaqxe"

# Define a plain Python function, this becomes our first task
def validate_seed_file():
    # Build the full path to the seed CSV inside the container
    seed_path = os.path.join(DBT_PROJECT_DIR, "seeds", "college_major_roi.csv")
    # Check the file actually exists, stop the pipeline early if not
    if not os.path.exists(seed_path):
        raise FileNotFoundError(f"Seed file missing: {seed_path}")
    # Get the file's size in bytes
    size = os.path.getsize(seed_path)
    # Check it isn't an empty file, stop the pipeline early if so
    if size == 0:
        raise ValueError("Seed file is empty")
    # Print a confirmation message, visible in the task's logs later
    print(f"Seed file found, size: {size} bytes")

# Start defining the DAG itself, "with" means everything indented
# below belongs to this DAG
with DAG(
    # A unique internal name for this pipeline, shown in the Airflow UI
    dag_id="college_roi_pipeline",
    # A human-readable description, also shown in the UI
    description="Validate, seed, transform, and test the college major ROI dataset",
    # The earliest date Airflow considers this DAG "active" from
    start_date=datetime(2026, 9, 1),
    # No automatic schedule, only runs when you manually trigger it
    schedule=None,
    # Don't try to "catch up" on any past scheduled runs since start_date
    catchup=False,
    # Labels shown in the UI, purely for organising/filtering DAGs
    tags=["dbt", "snowflake", "college-roi"],
# "as dag" lets Airflow know this whole block defines one DAG object
) as dag:

    # Task 1: run our Python validation function as an Airflow task
    validate = PythonOperator(
        # Unique name for this task within the DAG
        task_id="validate_seed_file",
        # Which Python function this task actually runs
        python_callable=validate_seed_file,
    )

    # Task 2: run "dbt seed" as a shell command
    seed = BashOperator(
        task_id="dbt_seed",
        # cd into the project folder first, then run dbt seed
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt seed",
    )

    # Task 3: run "dbt run" to build all silver and gold models
    run = BashOperator(
        task_id="dbt_run",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt run",
    )

    # Task 4: run "dbt test" to check all the tests we defined pass
    test = BashOperator(
        task_id="dbt_test",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt test",
    )

    # This line defines the order tasks run in: validate first,
    # then seed, then run, then test. Each only starts if the one
    # before it succeeded. ">>" means "then run this next".
    validate >> seed >> run >> test