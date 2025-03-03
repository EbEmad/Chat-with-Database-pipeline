select *
from bronze.crm_sales_info
where sls_cust_id not in (select cst_id from silver.crm_cust_info);

-- check invalid dates
select  COALESCE(sls_order_dt,0) as sls_order_dt
from bronze.crm_sales_info
where sls_order_dt<=0 or length(sls_order_dt);