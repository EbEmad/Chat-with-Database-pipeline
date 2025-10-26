/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/
drop table if exists silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_material_status VARCHAR(50),
    cst_gndr varchar(50),
    cst_create_date DATE,
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

drop table if exists silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
    prd_id int,
    cat_id varchar(50),
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost float,
    prd_line VARCHAR(50),
    prd_start_dt date,
    prd_end_dt date,
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

drop table if exists silver.crm_sales_info;
CREATE TABLE silver.crm_sales_info (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id int,
    sls_order_dt date,
    sls_ship_dt date,
    sls_due_dt date,
    sls_sales int,
    sls_quantity int,
    sls_price int,
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

drop table if exists silver.prm_cust;
CREATE TABLE silver.prm_cust (
    Cid varchar(50),
    Bdate date,
    Gender varchar(50),
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

drop table if exists silver.prm_loc;
CREATE TABLE silver.prm_loc (
    Cid varchar(50),
    cntry varchar(50),
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

drop table if exists silver.prm_px_cat;
CREATE TABLE silver.prm_px_cat (
    id varchar(50),
    cat varchar(50),
    subcat varchar(50),
    mantance varchar(50),
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

