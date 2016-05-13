select
	l_shipmode,
	sum(1) as high_line_count,
	sum(1) as low_line_count
from
	orders,
	lineitem
where
	o_orderkey = l_orderkey
	and (l_shipmode = 'MAIL' or l_shipmode = 'SHIP')
	and l_commitdate < l_receiptdate
	and l_shipdate < l_commitdate
	and l_receiptdate >= date '1994-01-01'
	and l_receiptdate < date '1994-01-01' + interval '1' year
group by
	l_shipmode
;
