-- =============================================================
-- Create Database and Schemas
-- =============================================================
-- WARNING:
-- Running this script will DROP the existing database if it exists.
-- All data will be permanently deleted. Proceed with caution!
-- =============================================================

-- Connect to a safe database before dropping
\c postgres

-- Drop and recreate the database
DROP DATABASE IF EXISTS "DataWarehouse";
CREATE DATABASE "DataWarehouse";

-- Connect to the new database
\c "DataWarehouse"

-- Create schemas
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;
