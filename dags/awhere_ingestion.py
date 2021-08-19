from airflow import DAG
from myairflow.lib.airflow.operators.awhere_operator import AwhereToS3Operator
from datetime import date, timedelta, datetime
import os

start_day = datetime.now() - timedelta(days=1)
yesterday = date.today() - timedelta(days=1)

default_args = {
    'owner': 'airflow',
    'depends_on': False,
    'start_date': start_day,
    'email': [''],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    'schedule_interval': '@daily'
}

with DAG(
    dag_id='awhere_ingestion',
    default_args=default_args,
    description='Daily ingestion of climate data',
    catchup=False
    ) as dag:

    ingestion_task = AwhereToS3Operator(
        task_id='daily_denver_climate_ingestion',
        description='fetch data json from Awhere API and store raw record to S3',
        dataset_url='https://api.awhere.com/v2/weather/fields/{}/observations/{}'.format('denver',str(yesterday)),
        s3_bucket='troys-awesome-bucket',
        s3_key='s3://troys-awesome-bucket/awhere/ingestion/{}/climate_{}.json'.format('denver',str(yesterday)),
        replace=True
    )

    ingestion_task


