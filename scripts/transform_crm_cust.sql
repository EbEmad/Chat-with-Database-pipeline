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

