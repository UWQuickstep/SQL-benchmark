-- The blocksizes and storage types were chosen because they were experimentally
-- determined to be the fastest on the Quickstep CHTC machine.

create table lineorder (
lo_orderkey int not null,
lo_linenumber int not null,
lo_custkey int not null,
lo_partkey int not null,
lo_suppkey int not null,
lo_orderdate int not null,
lo_orderpriority char(15) not null,
lo_shippriority char(1) not null,
lo_quantity int not null,
lo_extendedprice int not null,
lo_ordtotalprice int not null,
lo_discount int not null,
lo_revenue int not null,
lo_supplycost int not null,
lo_tax int not null,
lo_commitdate int not null,
lo_shipmode char(10) not null
) WITH BLOCKPROPERTIES (
  TYPE compressed_columnstore,
  SORT lo_orderkey,
  COMPRESS ALL,
  BLOCKSIZEMB 32);

create table part (
p_partkey int not null,
p_name varchar(22) not null,
p_mfgr char(6) not null,
p_category char(7) not null,
p_brand1 char(9) not null,
p_color varchar(11) not null,
p_type varchar(25) not null,
p_size int not null,
p_container char(10) not null
) WITH BLOCKPROPERTIES (
  TYPE split_rowstore,
  BLOCKSIZEMB 32);

create table supplier (
s_suppkey int not null,
s_name char(25) not null,
s_address varchar(25) not null,
s_city char(10) not null,
s_nation char(15) not null,
s_region char(12) not null,
s_phone char(15) not null
) WITH BLOCKPROPERTIES (
  TYPE split_rowstore,
  BLOCKSIZEMB 32);

create table customer (
c_custkey int not null,
c_name varchar(25) not null,
c_address varchar(25) not null,
c_city char(10) not null,
c_nation char(15) not null,
c_region char(12) not null,
c_phone char(15) not null,
c_mktsegment char(10) not null
) WITH BLOCKPROPERTIES (
  TYPE split_rowstore,
  BLOCKSIZEMB 32);

create table ddate (
d_datekey int not null,
d_date char(18) not null,
d_dayofweek char(9) not null,
d_month char(9) not null,
d_year int not null,
d_yearmonthnum int not null,
d_yearmonth char(7) not null,
d_daynuminweek int not null,
d_daynuminmonth int not null,
d_daynuminyear int not null,
d_monthnuminyear int not null,
d_weeknuminyear int not null,
d_sellingseason varchar(12) not null,
d_lastdayinweekfl int not null,
d_lastdayinmonthfl int not null,
d_holidayfl int not null,
d_weekdayfl int not null
) WITH BLOCKPROPERTIES (
  TYPE split_rowstore,
  BLOCKSIZEMB 2);

