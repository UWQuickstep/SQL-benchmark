SELECT c_city, s_city, d_year, SUM(lo_revenue) AS revenue
FROM customer, lineorder, supplier, ddate   
WHERE lo_custkey = c_custkey
  AND lo_suppkey = s_suppkey
  AND lo_orderdate = d_datekey
  AND (c_city = 'UNITED K11' OR c_city = 'UNITED K15')
  AND (s_city = 'UNITED K11' OR s_city = 'UNITED K15')
  AND d_yearmonth = 'Dec1997'
GROUP BY c_city, s_city, d_year
ORDER BY d_year ASC, revenue DESC;
