select cst_id, count(*)
from silver.crm_cust_info
group by cst_id
having count(*)>1 ;

-- get the last updated date
select *
from(
select *,row_number() over(partition by cst_id order by cst_create_date   desc) flag_last
from silver.crm_cust_info ) as t where flag_last=1 and cst_id=29466;
--where cst_id=29466;


-- check uwanted spaces
-- expectation no result
/*
select cst_firstname
from silver.crm_cust_info
where cst_firstname!=trim(cst_firstname);
*/
-- equal form
select cst_firstname
from silver.crm_cust_info
where cst_firstname like '% ' or cst_firstname like ' %';


-- data standardiaztion & Consistency
select distinct cst_gndr
from silver.crm_cust_info;

select distinct cst_material_status
from silver.crm_cust_info;

select *
from silver.crm_cust_info;