 
 create view gold.dim_customers as
 select 
    row_number() over (order by cst_id) as customer_key,
    ci.cst_id as customer_id,
    ci.cst_key as customer_number,
    ci.cst_firstname as first_name,
    ci.cst_lastname as last_name,
    la.cntry as country,
 case when ci.cst_gndr!='n/a' then ci.cst_gndr -- crm is the master for gender info
    else COALESCE(ca.gender,'n/a')
    end as gender,
    ci.cst_create_date as create_date,
    ca.bdate as birthdate,
     ci.cst_material_status as marital_status
  
from silver.crm_cust_info ci left join silver.prm_cust ca on ci.cst_key=ca.cid
left join silver.prm_loc la on ci.cst_key=la.cid;



create view gold.dim_products as
SELECT 
row_number() over(order by pn.prd_start_dt,pn.prd_key) as product_key,
pn.prd_id as product_id,
pn.prd_key as product_number,
pn.prd_nm as product_name,
pn.cat_id as category_id,
pc.cat as category,
pc.subcat as subcategory,
pc.mantance as maintenance,
pn.prd_cost as cost,
pn.prd_line as product_line,
pn.prd_start_dt as start_date
FROM silver.crm_prd_info pn left join silver.prm_px_cat pc on pn.cat_id=pc.id;



drop view if exists gold.fact_sales;

create view gold.fact_sales as
SELECT sls_ord_num as order_number,
pr.product_key ,
cu.customer_key,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amount,
sd.sls_quantity as quanity,
sd.sls_price  as price
FROM crm_sales_info sd left join gold.dim_products pr  on sd.sls_prd_key=pr.product_number
left join gold.dim_customers cu on sd.sls_cust_id=cu.customer_id ;