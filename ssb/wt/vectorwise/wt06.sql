\rt
select sum(lo_revenue), d_year, p_brand1
from widetable 
where p_brand1 = 'MFGR#2221'
	and s_region = 'EUROPE'
group by d_year, p_brand1
order by d_year, p_brand1\g
