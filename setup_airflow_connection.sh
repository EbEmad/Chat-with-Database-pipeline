#!/bin/bash

# Script to setup Airflow PostgreSQL connection
# This script adds the postgres_conn connection to Airflow

echo "Setting up Airflow PostgreSQL connection..."

# Get the webserver container name
WEBSERVER_CONTAINER=$(docker ps --filter "name=webserver" --format "{{.Names}}")

if [ -z "$WEBSERVER_CONTAINER" ]; then
    echo "Error: Airflow webserver container not found!"
    echo "Please make sure docker-compose is running: docker-compose up -d"
    exit 1
fi

echo "Found webserver container: $WEBSERVER_CONTAINER"

# Wait for Airflow to be ready
echo "Waiting for Airflow to be ready..."
sleep 10

# Add the connection
docker exec -it $WEBSERVER_CONTAINER airflow connections add 'postgres_conn' \
    --conn-type 'postgres' \
    --conn-host 'db' \
    --conn-schema 'DataWarehouse' \
    --conn-login 'postgres' \
    --conn-password 'postgres123' \
    --conn-port '5432'

if [ $? -eq 0 ]; then
    echo "✓ Connection 'postgres_conn' added successfully!"
    echo ""
    echo "You can now:"
    echo "1. Open Airflow UI at http://localhost:8080"
    echo "2. Login with admin/admin"
    echo "3. Trigger the DAG: table_on_postgres"
else
    echo "✗ Failed to add connection. You may need to set it up manually via the UI."
fi

