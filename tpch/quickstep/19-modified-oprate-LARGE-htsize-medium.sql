SELECT l_extendedprice, l_discount
FROM
lineitem,part
WHERE p_partkey = l_partkey
AND l_shipdate > date '1992-02-02'  -- LARGE --99% 598M rows
AND p_brand = 'Brand#12'  -- medium 25 MB
;