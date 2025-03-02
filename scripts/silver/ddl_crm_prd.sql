select *
from ( select  replace(substring(prd_key,1,5),'-','_') cat_id from bronze.crm_prd_info) as t
where cat_id not in (
select  id
from bronze.prm_px_cat
);
-- we notice that there is a relation between two tables so we're gonna corrct the data inside
select substring(prd_key,7,len(prd_key))
from bronze.crm_prd_info;
-- check nulls or duplicates in primary key
-- expectation: no result
select prd_id, count(*)
from bronze.crm_prd_info
group by prd_id
having count(*)>1  or prd_id is null;
