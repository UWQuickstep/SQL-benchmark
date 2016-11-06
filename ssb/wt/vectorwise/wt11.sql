\rt
select d_year, c_nation, sum(lo_revenue-lo_supplycost) as profit1
from widetable 
where c_region = 'AMERICA'
	and s_region = 'AMERICA'
	and (p_mfgr = 'MFGR#1' or p_mfgr = 'MFGR#2')
group by d_year, c_nation
order by d_year, c_nation\g
