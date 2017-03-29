select c_nation, s_nation, d_year, sum(lo_revenue) as revenue
	from customer, lineorder, supplier, ddate
	where lo_custkey = c_custkey
		and lo_suppkey = s_suppkey
		and lo_orderdate = d_datekey
		and c_region = 'ASIA'
		--and s_region = 'ASIA' 
    and (s_region= 'ASIA')
		--and d_year >= 1992 and d_year <= 1997
    --and (d_month = 'January' or d_month = 'December')
    and lo_quantity < 25
	group by c_nation, s_nation, d_year
	order by d_year asc, revenue desc;