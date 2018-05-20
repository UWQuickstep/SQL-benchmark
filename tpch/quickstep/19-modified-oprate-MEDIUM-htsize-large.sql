SELECT l_extendedprice, l_discount
FROM
lineitem,part
WHERE p_partkey = l_partkey
AND l_shipinstruct = 'DELIVER IN PERSON'  -- MEDIUM 25%, 150M rows
AND p_size > 5 -- large 562 MB
;