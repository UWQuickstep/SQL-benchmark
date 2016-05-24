source monetdb.cfg

monetdb -p 54322 stop ssb100
monetdb -p 54322 destroy ssb100

monetdb -p 54322 create ssb100
monetdb -p 54322 release ssb100

mclient -p 54322 -d ssb100 < create.sql
