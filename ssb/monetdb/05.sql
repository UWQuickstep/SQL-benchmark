select sum(lo_revenue), d_year, p_brand1
	from lineorder, ddate, part, supplier
	where lo_partkey = p_partkey
		and lo_suppkey = s_suppkey
    and lo_orderdate = d_datekey
		and p_brand1 between 'MFGR#2221' and 'MFGR#2228'
		and s_region = 'ASIA'
	group by d_year, p_brand1
	order by d_year, p_brand1;