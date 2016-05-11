-- This script is kept here as an example. It has problems with memory usage in
-- current version. Also, to do this right, the INSERT command must use a FULL
-- OUTER JOIN, which is not supported.

drop table widetable;

create table widetable (
lo_orderkey int not null,
lo_linenumber int not null,
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
lo_shipmode char(10) not null,
p_name varchar(22) not null,
p_mfgr char(6) not null,
p_category char(7) not null,
p_brand1 char(9) not null,
p_color varchar(11) not null,
p_type varchar(25) not null,
p_size int not null,
p_container char(10) not null,
s_name char(25) not null,
s_address varchar(25) not null,
s_city char(10) not null,
s_nation char(15) not null,
s_region char(12) not null,
s_phone char(15) not null,
c_name varchar(25) not null,
c_address varchar(25) not null,
c_city char(10) not null,
c_nation char(15) not null,
c_region char(12) not null,
c_phone char(15) not null,
c_mktsegment char(10) not null,
d_date_order char(18) not null,
d_dayofweek_order char(9) not null,
d_month_order char(9) not null,
d_year_order int not null,
d_yearmonthnum_order int not null,
d_yearmonth_order char(7) not null,
d_daynuminweek_order int not null,
d_daynuminmonth_order int not null,
d_daynuminyear_order int not null,
d_monthnuminyear_order int not null,
d_weeknuminyear_order int not null,
d_sellingseason_order varchar(12) not null,
d_lastdayinweekfl_order int not null,
d_lastdayinmonthfl_order int not null,
d_holidayfl_order int not null,
d_weekdayfl_order int not null,
d_date_commit char(18) not null,
d_dayofweek_commit char(9) not null,
d_month_commit char(9) not null,
d_year_commit int not null,
d_yearmonthnum_commit int not null,
d_yearmonth_commit char(7) not null,
d_daynuminweek_commit int not null,
d_daynuminmonth_commit int not null,
d_daynuminyear_commit int not null,
d_monthnuminyear_commit int not null,
d_weeknuminyear_commit int not null,
d_sellingseason_commit varchar(12) not null,
d_lastdayinweekfl_commit int not null,
d_lastdayinmonthfl_commit int not null,
d_holidayfl_commit int not null,
d_weekdayfl_commit int not null);

create index bw_1 on widetable (lo_discount) using bitweaving (type v);
create index bw_2 on widetable (lo_quantity) using bitweaving (type v);
create index bw_3 on widetable (p_mfgr) using bitweaving (type v);
create index bw_4 on widetable (p_category) using bitweaving (type v);
create index bw_5 on widetable (p_brand1) using bitweaving (type v);
create index bw_6 on widetable (s_city) using bitweaving (type v);
create index bw_7 on widetable (s_nation) using bitweaving (type v);
create index bw_8 on widetable (s_region) using bitweaving (type v);
create index bw_9 on widetable (c_city) using bitweaving (type v);
create index bw_10 on widetable (c_nation) using bitweaving (type v);
create index bw_11 on widetable (c_region) using bitweaving (type v);
create index bw_12 on widetable (d_year_order) using bitweaving (type v);
create index bw_13 on widetable (d_yearmonthnum_order) using bitweaving (type v);
create index bw_14 on widetable (d_yearmonth_order) using bitweaving (type v);
create index bw_15 on widetable (d_weeknuminyear_order) using bitweaving (type v);
create index bw_16 on widetable (d_year_commit) using bitweaving (type v);
create index bw_17 on widetable (d_yearmonthnum_commit) using bitweaving (type v);
create index bw_18 on widetable (d_yearmonth_commit) using bitweaving (type v);
create index bw_19 on widetable (d_weeknuminyear_commit) using bitweaving (type v);

insert into widetable
  select 
    lo_orderkey,
    lo_linenumber,
    lo_orderpriority,
    lo_shippriority,
    lo_quantity,
    lo_extendedprice,
    lo_ordtotalprice,
    lo_discount,
    lo_revenue,
    lo_supplycost,
    lo_tax,
    lo_commitdate,
    lo_shipmode,
    p_name,
    p_mfgr,
    p_category,
    p_brand1,
    p_color,
    p_type,
    p_size,
    p_container,
    s_name,
    s_address,
    s_city,
    s_nation,
    s_region,
    s_phone,
    c_name,
    c_address,
    c_city,
    c_nation,
    c_region,
    c_phone,
    c_mktsegment,
    d1.d_date,
    d1.d_dayofweek,
    d1.d_month,
    d1.d_year,
    d1.d_yearmonthnum,
    d1.d_yearmonth,
    d1.d_daynuminweek,
    d1.d_daynuminmonth,
    d1.d_daynuminyear,
    d1.d_monthnuminyear,
    d1.d_weeknuminyear,
    d1.d_sellingseason,
    d1.d_lastdayinweekfl,
    d1.d_lastdayinmonthfl,
    d1.d_holidayfl,
    d1.d_weekdayfl,
    d2.d_date,
    d2.d_dayofweek,
    d2.d_month,
    d2.d_year,
    d2.d_yearmonthnum,
    d2.d_yearmonth,
    d2.d_daynuminweek,
    d2.d_daynuminmonth,
    d2.d_daynuminyear,
    d2.d_monthnuminyear,
    d2.d_weeknuminyear,
    d2.d_sellingseason,
    d2.d_lastdayinweekfl,
    d2.d_lastdayinmonthfl,
    d2.d_holidayfl,
    d2.d_weekdayfl
  from lineorder, customer, supplier, part, ddate as d1, ddate as d2
  where lo_custkey = c_custkey AND 
        lo_partkey = p_partkey AND
        lo_suppkey = s_suppkey AND
        lo_orderdate = d1.d_datekey AND
        lo_commitdate = d2.d_datekey;

