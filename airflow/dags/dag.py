from airflow import DAG
from datetime import datetime, timedelta
from airflow.providers.postgres.operators.postgres import PostgresOperator


with DAG(
    dag_id='table_on_postgres',   
    description='this is a pipeline on postgres',
    start_date=datetime(2025, 9, 26),
    schedule_interval='@daily',  
    catchup=False,
    tags=['data_engineering'],
    dagrun_timeout=timedelta(minutes=30)  ,
    template_searchpath=['/opt/airflow/scripts'], 
) as dag:
    create_table_bronze = PostgresOperator(
        task_id='create_table_bronze',
        postgres_conn_id='postgres_conn',
        sql='bronze/ddl_bronze.sql'
    )
    create_table_silver = PostgresOperator(
        task_id='create_table_silver',
        postgres_conn_id='postgres_conn',
        sql='silver/ddl_silver.sql'
    )
    create_table_gold = PostgresOperator(
        task_id='create_table_gold',
        postgres_conn_id='postgres_conn',
        sql='gold/ddl_gold.sql'
    )
    insert_data_bronze = PostgresOperator(
        task_id='insert_data_bronze',
        postgres_conn_id='postgres_conn',
        sql='bronze/load_bronze.sql'
    )
    insert_data_silver = PostgresOperator(
        task_id='insert_data_silver',
        postgres_conn_id='postgres_conn',
        sql='silver/load_silver.sql'
    )
    insert_data_gold = PostgresOperator(
        task_id='insert_data_gold',
        postgres_conn_id='postgres_conn',
        sql='gold/load_gold.sql'
    )
    create_table_bronze >> insert_data_bronze >> create_table_silver >> insert_data_silver >> create_table_gold >> insert_data_gold
