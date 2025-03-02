select *  from bronze.crm_cust_info limit 100;
select * from bronze.crm_prd_info limit 100;
select * from bronze.crm_sales_info limit 100;
select * from bronze.prm_cust limit 100;
select * from bronze.prm_loc  limit 100;
select * from bronze.prm_px_cat  limit 100;


-- check nulls or duplicates in primary key
-- expectation: no result
select *
from bronze.crm_cust_info;
select cst_id, count(*)
from bronze.crm_cust_info
group by cst_id
having count(*)>1 ;

-- get the last updated date
select *
from(
select *,row_number() over(partition by cst_id order by cst_create_date   desc) flag_last
from bronze.crm_cust_info ) as t where flag_last=1 and cst_id=29466;
--where cst_id=29466;


-- check uwanted spaces
-- expectation no result
/*
select cst_firstname
from bronze.crm_cust_info
where cst_firstname!=trim(cst_firstname);
*/
-- equal form
select cst_firstname
from bronze.crm_cust_info
where cst_firstname like '% ' or cst_firstname like ' %';


-- data standardiaztion & Consistency
select distinct cst_gndr
from bronze.crm_cust_info;

select distinct cst_material_status
from bronze.crm_cust_info;