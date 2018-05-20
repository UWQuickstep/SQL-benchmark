SELECT l_extendedprice, l_discount
FROM
lineitem,part
WHERE p_partkey = l_partkey
AND l_shipdate > date '1992-02-02'  -- LARGE --99% 598M rows
AND p_size = 2 and p_brand='Brand#12' and p_retailprice between 1810.0 and 1820.0  -- tiny 147 rows, 4 KB
;