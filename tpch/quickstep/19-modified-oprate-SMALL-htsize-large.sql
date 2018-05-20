SELECT l_extendedprice, l_discount
FROM
lineitem,part
WHERE p_partkey = l_partkey
AND l_shipinstruct = 'DELIVER IN PERSON' and (l_shipmode = 'AIR' or l_shipmode = 'AIR REG')  -- SMALL 3.5% 21M rows
AND p_size > 5 -- large 562 MB
;