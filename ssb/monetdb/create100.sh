source monetdb.cfg

monetdb stop ssb100
monetdb destroy ssb100

monetdb create ssb100
monetdb release ssb100

mclient -d ssb100 < create.sql
