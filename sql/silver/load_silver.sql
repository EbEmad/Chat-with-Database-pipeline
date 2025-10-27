
CREATE OR REPLACE PROCEDURE silver.insertsilver()
LANGUAGE plpgsql 
AS $$
BEGIN
raise notice 'Truncating the table silver.crm_cust_info';
TRUNCATE table silver.prm_px_cat;
raise notice 'Inserting the table silver.crm_cust_info';

------ transform crm_cust_info ----------
insert into silver.crm_cust_info (
    cst_id,cst_key,cst_firstname,cst_lastname,cst_gndr,cst_material_status,cst_create_date
)
select cst_id,cst_key,trim(cst_firstname) as cst_firstname,
trim(cst_lastname) as cst_lastname,
case when upper(trim(cst_gndr)) ='F' then 'Female'
    when upper(trim(cst_gndr)) ='M' then 'Male'
    else 'n/a' end  cst_gndr,
case when upper(trim(cst_material_status)) ='S' then 'Single'
    when upper(trim(cst_material_status)) ='M' then 'Married'
    else 'n/a' end  cst_material_status,cst_create_date
from (
    select *,row_number() over(PARTITION BY cst_id order by cst_create_date desc) as flag_last
    from bronze.crm_cust_info
    where cst_id is not NULL
) as t where flag_last=1;
------ transform crm_prd_info ----------

raise notice 'Truncating the table silver.crm_prd_info ';
TRUNCATE table silver.crm_prd_info;
raise notice 'Inserting the table silver.crm_prd_info ';

insert into silver.crm_prd_info(
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
select prd_id,
replace(substring(prd_key,1,5),'-','_') as cat_id,
substring(prd_key,7,length(prd_key)) as prd_key,
prd_nm,
coalesce(prd_cost,0)as prd_cost,
case upper(trim(prd_line))
when 'M' then 'Mountain'
 when 'R' then 'Read'
 when 'S' then 'Other Sales'
 when 'T' then 'Touring'
else 'n/a'
end as prd_line,
cast(prd_start_dt as date) as prd_start_dt,
cast(lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 as date) as prd_end_dt
from bronze.crm_prd_info;

------ transform crm_prd_info ----------
raise notice 'Truncating the table silver.crm_sales_info ';
TRUNCATE table silver.crm_sales_info;
raise notice 'Inserting the table silver.crm_sales_info ';
insert into silver.crm_sales_info(
            sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
)
SELECT sls_ord_num,
sls_prd_key,
sls_cust_id,
case when cast(sls_order_dt as integer)=0 or length(sls_order_dt )!=8
then null
else cast(cast(sls_order_dt as varchar) as date)
end as sls_order_dt,
case when cast(sls_ship_dt as integer)=0 or length(sls_ship_dt )!=8
then null
else cast(cast(sls_ship_dt as varchar) as date)
end  as sls_ship_dt,
case when cast(sls_due_dt as integer)=0 or length(sls_due_dt )!=8
then null
else cast(cast(sls_due_dt as varchar) as date)
end sls_due_dt,
case when  sls_sales is null or sls_sales<=0 or sls_sales!=sls_quantity*abs(sls_price)
    then sls_quantity*abs(sls_price)
    else sls_sales
    end as sls_sales,
sls_quantity,
case when  sls_sales is null or sls_sales<=0 or sls_sales!=sls_quantity*abs(sls_price)
    then sls_quantity*abs(sls_price)
    else sls_sales
    end as sls_price
FROM bronze.crm_sales_info;


------ transform prm_cust ----------
raise notice 'Truncating the table silver.prm_cust ';
TRUNCATE table silver.prm_cust;
raise notice 'Inserting the table silver.prm_cust ';

insert into silver.prm_cust(
    cid,
    bdate,
    gender
)
SELECT 
case when cid like 'NAS%' 
THEN substring(cid,4,length(cid))
else cid
end as cid,
case when bdate>now() then NULL
    else bdate
end as bdate,
case when upper(trim(gender)) in ('F','FEMALE') then 'Female'
    when upper(trim(gender)) in ('M','MALE') then 'Male'
    else 'n/a'
    end as gender
FROM bronze.prm_cust;

------ transform prm_loc ----------
raise notice 'Truncating the table silver.prm_loc ';
TRUNCATE table silver.prm_loc;
raise notice 'Inserting the table silver.prm_loc ';

insert into silver.prm_loc(
    cid,cntry
)
SELECT REPLACE(cid,'-','') as cid ,
case when trim(cntry) = 'DE' then 'Germany'
    when trim(cntry) in ('US','USA') then 'United States'
    when trim(cntry) = '' or cntry is null then 'n/a'
    else trim(cntry)
    end as cntry

FROM bronze.prm_loc;


------ transform prm_px_cat ----------
raise notice 'Truncating the table silver.prm_px_cat ';
TRUNCATE table silver.prm_px_cat;
raise notice 'Inserting the table silver.prm_px_cat ';

insert into silver.prm_px_cat(
    id,
    cat,
    subcat,
    mantance
)
select id,cat,subcat,mantance
from bronze.prm_px_cat;
END $$;

call silver.insertsilver();
