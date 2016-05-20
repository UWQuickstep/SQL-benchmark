copy
select 
LO_ORDERKEY,
LO_LINENUMBER,
LO_CUSTKEY,
LO_PARTKEY,
LO_SUPPKEY,
LO_ORDERDATE,
LO_ORDERPRIORITY,
LO_SHIPPRIORITY,
LO_QUANTITY,
LO_EXTENDEDPRICE,
LO_ORDTOTALPRICE,
LO_DISCOUNT,
LO_REVENUE,
LO_SUPPLYCOST,
LO_TAX,
LO_COMMITDATE,
LO_SHIPMODE,
P_PARTKEY,
P_NAME,
P_MFGR,
P_CATEGORY,
P_BRAND1,
P_COLOR,
P_TYPE,
P_SIZE,
P_CONTAINER,
S_SUPPKEY,
S_NAME,
S_ADDRESS,
S_CITY,
S_NATION,
S_REGION,
S_PHONE,
C_CUSTKEY,
C_NAME,
C_ADDRESS,
C_CITY,
C_NATION,
C_REGION,
C_PHONE,
C_MKTSEGMENT,
D_DATEKEY,
D_DATE,
D_DAYOFWEEK,
D_MONTH,
D_YEAR,
D_YEARMONTHNUM,
D_YEARMONTH,
D_DAYNUMINWEEK,
D_DAYNUMINMONTH,
D_DAYNUMINYEAR,
D_MONTHNUMINYEAR,
D_WEEKNUMINYEAR,
D_SELLINGSEASON,
D_LASTDAYINWEEKFL,
D_LASTDAYINMONTHFL,
D_HOLIDAYFL,
D_WEEKDAYFL
from LINEORDER, PART, SUPPLIER, CUSTOMER, DDATE
where LO_CUSTKEY = C_CUSTKEY and LO_PARTKEY = P_PARTKEY and LO_SUPPKEY = S_SUPPKEY and LO_ORDERDATE = D_DATEKEY
into 'widetable.tbl' delimiters '|','|\n','';