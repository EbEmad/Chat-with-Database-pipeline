-- Active: 1740668000400@@localhost@5432@datawarehouse
create database DataWarehouse;
\c DataWarehouse;
create schema bronze;
create schema silver;
create schema gold;

create table bronze.crm_cust_info (
	id serial primary key,
	name varchar(255),
	email varchar(255),
	phone varchar(50)
);

copy bronze.crm_cust_info
 FROM '/home/ebrahim/sql-data-warehouse-project/datasets/source_crm/cust_info.csv' 
 WITH (FORMAT csv, HEADER, DELIMITER ',');


select *
from bronze.crm_cust_info;