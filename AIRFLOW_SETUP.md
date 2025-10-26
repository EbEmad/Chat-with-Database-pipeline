# Airflow Setup Guide

## Setting Up PostgreSQL Connection in Airflow

After starting your Airflow containers, you need to configure the PostgreSQL connection:

### Option 1: Using Airflow UI (Recommended)

1. Open Airflow UI at `http://localhost:8080`
   - Username: `admin`
   - Password: `admin`

2. Go to **Admin** → **Connections**

3. Click **+** to add a new connection with these settings:
   - **Connection Id**: `postgres_conn`
   - **Connection Type**: `Postgres`
   - **Host**: `db` (Docker service name)
   - **Schema**: `DataWarehouse`
   - **Login**: `postgres` (from .env POSTGRES_USER)
   - **Password**: `postgres123` (from .env POSTGRES_PASSWORD)
   - **Port**: `5432`

4. Click **Save**

### Option 2: Using Airflow CLI

```bash
docker exec -it <webserver_container_name> airflow connections add 'postgres_conn' \
    --conn-type 'postgres' \
    --conn-host 'db' \
    --conn-schema 'DataWarehouse' \
    --conn-login 'postgres' \
    --conn-password 'postgres123' \
    --conn-port '5432'
```

## Starting the Project

1. Make sure you have a `.env` file with proper credentials (already created)

2. Start all services:
   ```bash
   docker-compose up -d
   ```

3. Wait for services to be ready (check logs):
   ```bash
   docker-compose logs -f
   ```

4. Access Airflow UI: http://localhost:8080

5. Configure the PostgreSQL connection (see above)

6. Trigger the DAG: `table_on_postgres`

## Troubleshooting

- **Connection Error**: Make sure the `postgres_conn` connection is configured correctly
- **File Not Found Error**: Check that datasets are mounted to `/app` in the `db` container
- **Authentication Error**: Verify `.env` file has correct credentials

