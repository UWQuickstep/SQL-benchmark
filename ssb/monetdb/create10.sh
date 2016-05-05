source monetdb.cfg

monetdb stop ssb10
monetdb destroy ssb10

monetdb create ssb10
monetdb release ssb10

mclient -d ssb10 < create.sql
