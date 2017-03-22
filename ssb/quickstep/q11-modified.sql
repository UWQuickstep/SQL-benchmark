--select d_year, c_nation, sum(lo_revenue-lo_supplycost) as profit1
--	from ddate, customer, part, lineorder
--	where lo_partkey = p_partkey
--    and lo_custkey = c_custkey
--		and lo_orderdate = d_datekey
--		and (c_nation = 'UNITED KINGDOM' or c_nation = 'UNITED STATES')
--		and p_mfgr = 'MFGR#1'
--	group by d_year, c_nation
--	order by d_year, c_nation;
select s_region, c_nation, sum(lo_revenue-lo_supplycost) as profit1
	from customer, supplier, part, lineorder
	where lo_partkey = p_partkey
		and lo_suppkey = s_suppkey
    and lo_custkey = c_custkey
		-- and c_region = 'AMERICA'
		and (c_nation = 'UNITED KINGDOM' or c_nation = 'UNITED STATES')
		and (s_region = 'AMERICA' or s_region = 'EUROPE' or s_region = 'ASIA')
		-- and (p_mfgr = 'MFGR#1' or p_mfgr = 'MFGR#2')
		and p_mfgr = 'MFGR#1'
    and lo_quantity < 10
	group by s_region, c_nation
	order by s_region, c_nation;
