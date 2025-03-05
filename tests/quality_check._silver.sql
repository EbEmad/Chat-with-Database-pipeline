/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.crm_cust_info'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Data Standardization & Consistency
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;

-- ====================================================================
-- Checking 'silver.crm_prd_info'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    prd_id,
    COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    prd_nm 
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULLs or Negative Values in Cost
-- Expectation: No Results
SELECT 
    prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization & Consistency
SELECT DISTINCT 
    prd_line 
FROM silver.crm_prd_info;

-- Check for Invalid Date Orders (Start Date > End Date)
-- Expectation: No Results
SELECT 
    * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- Checking 'silver.crm_sales_details'
-- ====================================================================
-- Check for Invalid Dates
-- Expectation: No Invalid Dates\-- check the relation between the  tables
SELECT sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_info
 where sls_cust_id not in (select cst_id from silver.crm_cust_info);

 -- check for invalid issues
select sls_due_dt
from bronze.crm_sales_info
where cast(sls_due_dt as integer)<=0 or 
length(sls_due_dt)!=8 or 
cast(sls_due_dt as integer) >20500101;
-- check for Invalid Date orders
SELECT * 
from bronze.crm_sales_info
where cast(sls_order_dt as integer)>cast(sls_ship_dt as integer) or 
cast(sls_order_dt as integer)>cast(sls_due_dt as integer);

-- check data consistency between sales and quantity and price
select  distinct sls_sales as sls_sales_old,
sls_quantity,
sls_price as sls_price_old,
case when  sls_sales is null or sls_sales<=0 or sls_sales!=sls_quantity*abs(sls_price)
    then sls_quantity*abs(sls_price)
    else sls_sales
    end as sls_sales,
case when sls_price is null or sls_price<=0
then sls_sales/ NULLIF(sls_quantity,0)
else sls_price
end as sls_price
from bronze.crm_sales_info
where sls_sales!=sls_quantity*sls_price
or sls_quantity is null or sls_sales is null or sls_price is null or
sls_quantity <=0 or sls_sales <=0 or sls_price <=0
order by sls_sales,sls_quantity,sls_price;