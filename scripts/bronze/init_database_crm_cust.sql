drop  table if exists bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_material_status VARCHAR(50),
    cst_gndr varchar(50),
    cst_create_date DATE
);
drop  table if exists bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
    prd_id int,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost float,
    prd_line VARCHAR(50),
    prd_start_dt date,
    prd_end_dt date
);
drop  table if exists bronze.crm_sales_info;
CREATE TABLE bronze.crm_sales_info (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id int,
    sls_order_dt VARCHAR(50),
    sls_ship_dt VARCHAR(50),
    sls_due_dt VARCHAR(50),
    sls_sales int,
    sls_quantity  int ,
    sls_price int
);
drop  table if exists bronze.prm_cust;
CREATE TABLE bronze.prm_cust (
    Cid varchar(50),
   Bdate date,
    Gender varchar(50)
);
drop  table if exists bronze.prm_loc;

CREATE TABLE bronze.prm_loc (
    Cid varchar(50),
    cntry varchar(50)
);
drop  table if exists bronze.prm_px_cat ;
CREATE TABLE bronze.prm_px_cat (
   id varchar(50),
   cat varchar(50),
   subcat varchar(50),
   mantance varchar(50)
);

