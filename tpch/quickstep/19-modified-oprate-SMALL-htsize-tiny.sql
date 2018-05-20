SELECT l_extendedprice, l_discount
FROM
lineitem,part
WHERE p_partkey = l_partkey
AND l_shipinstruct = 'DELIVER IN PERSON' and (l_shipmode = 'AIR' or l_shipmode = 'AIR REG')  -- SMALL 3.5% 21M rows
AND p_size = 2 and p_brand='Brand#12' and p_retailprice between 1810.0 and 1820.0  -- tiny 147 rows, 4 KB
;