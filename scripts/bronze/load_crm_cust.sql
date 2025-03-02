-- Active: 1740668000400@@localhost@5432@datawarehouse@silver
CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql 
AS $$
BEGIN
    declare 
    start_time TIMESTAMP ;
    end_time TIMESTAMP;
    duration DOUBLE PRECISION;
    BEGIN
        start_time:=NOW();
        raise notice 'insering bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
        COPY bronze.crm_cust_info
        FROM '/app/source_crm/cust_info.csv'
        WITH (FORMAT csv, HEADER, DELIMITER ',');
        end_time=now();
        duration := EXTRACT(EPOCH FROM (end_time - start_time));
        raise notice 'Load Duration %seconds', duration;
        raise notice '----------------------------------------';
        start_time:=NOW();
        raise notice 'insering bronze.crm_prd_info';  
        TRUNCATE TABLE bronze.crm_prd_info;
        COPY bronze.crm_prd_info
        FROM '/app/source_crm/prd_info.csv'
        WITH (FORMAT csv, HEADER, DELIMITER ',');
        end_time=now();
        duration := EXTRACT(EPOCH FROM (end_time - start_time));
        raise notice '----------------------------------------';
        start_time:=NOW();
        raise notice 'insering bronze.crm_sales_info'; 
        TRUNCATE TABLE bronze.crm_sales_info;
        COPY bronze.crm_sales_info
        FROM '/app/source_crm/sales_details.csv'
        WITH (FORMAT csv, HEADER, DELIMITER ',');
        end_time=now();
        raise notice '----------------------------------------';
        start_time:=NOW();
        raise notice 'insering bronze.prm_cust'; 
        TRUNCATE TABLE bronze.prm_cust;
        COPY bronze.prm_cust
        FROM '/app/source_erp/CUST_AZ12.csv'
        WITH (FORMAT csv, HEADER, DELIMITER ',');
        end_time=now();
        raise notice '----------------------------------------';
        start_time:=NOW();
         raise notice 'insering bronze.prm_loc'; 
        TRUNCATE TABLE bronze.prm_loc;
        COPY bronze.prm_loc
        FROM '/app/source_erp/LOC_A101.csv'
        WITH (FORMAT csv, HEADER, DELIMITER ',');
        end_time=now();
        raise notice '----------------------------------------';
        start_time:=NOW();
        raise notice 'insering bronze.prm_px_cat'; 
        TRUNCATE TABLE bronze.prm_px_cat;
        COPY bronze.prm_px_cat
        FROM '/app/source_erp/PX_CAT_G1V2.csv'
        WITH (FORMAT csv, HEADER, DELIMITER ',');
        end_time=now();

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error occurred during loading bronze layer';
            RAISE NOTICE 'Error message: %', SQLERRM;
            RAISE NOTICE 'Error state: %', SQLSTATE;
    END;
END $$;
SELECT * FROM information_schema.tables WHERE table_schema = 'bronze' AND table_name = 'crm_cust_info';
