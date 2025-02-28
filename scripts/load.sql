create or alter procedure bronze.load_bronze ASC
begin
    truncate table bronze.crm_cust_info;
    COPY bronze.crm_cust_info
    FROM '/app/source_crm/cust_info.csv'
    WITH (FORMAT csv, HEADER , DELIMITER ',');
    --------------------------
    truncate table bronze.crm_prd_info;
    COPY bronze.crm_prd_info
    FROM '/app/source_crm/prd_info.csv'
    WITH (FORMAT csv, HEADER , DELIMITER ',');
    ----------------------------------
    truncate table bronze.crm_sales_info;
    COPY bronze.crm_sales_info
    FROM '/app/source_crm/sales_details.csv'
    WITH (FORMAT csv, HEADER , DELIMITER ',');
    ---------------------------------------
    truncate table bronze.prm_cust;
    COPY bronze.prm_cust
    FROM '/app/source_erp/CUST_AZ12.csv'
    WITH (FORMAT csv, HEADER , DELIMITER ',');
    ------------------------------------
    truncate table bronze.prm_loc;
    COPY bronze.prm_loc
    FROM '/app/source_erp/LOC_A101.csv'
    WITH (FORMAT csv, HEADER , DELIMITER ',');
    ------------------------------------------------
    truncate table bronze.prm_px_cat;
    COPY bronze.prm_px_cat
    FROM '/app/source_erp/PX_CAT_G1V2.csv'
    WITH (FORMAT csv, HEADER , DELIMITER ',');
end
select * from prm_cust