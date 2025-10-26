-- =============================================================
-- Create Database and Schemas
-- =============================================================
-- WARNING:
-- Running this script will DROP the existing database if it exists.
-- All data will be permanently deleted. Proceed with caution!
-- =============================================================

-- 1️ Drop and recreate the database (optional)
DROP DATABASE IF EXISTS "DataWarehouse";
CREATE DATABASE "DataWarehouse";

-- 2️ Connect to the new database
\c "DataWarehouse"

-- 3️⃣ Create schemas inside it
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;
