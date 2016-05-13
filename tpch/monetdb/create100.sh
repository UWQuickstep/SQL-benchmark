source monetdb.cfg

monetdb stop tpch100
monetdb destroy tpch100

monetdb create tpch100
monetdb release tpch100

mclient -d tpch100 < create.sql
