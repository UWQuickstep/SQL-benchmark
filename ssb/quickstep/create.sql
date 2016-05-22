-- The blocksizes and storage types were chosen because they were experimentally
-- determined to be the fastest on the Quickstep CHTC machine.

CREATE TABLE lineorder (
  lo_orderkey      INT NOT NULL,
  lo_linenumber    INT NOT NULL,
  lo_custkey       INT NOT NULL,
  lo_partkey       INT NOT NULL,
  lo_suppkey       INT NOT NULL,
  lo_orderdate     INT NOT NULL,
  lo_orderpriority CHAR(15) NOT NULL,
  lo_shippriority  CHAR(1) NOT NULL,
  lo_quantity      INT NOT NULL,
  lo_extendedprice INT NOT NULL,
  lo_ordtotalprice INT NOT NULL,
  lo_discount      INT NOT NULL,
  lo_revenue       INT NOT NULL,
  lo_supplycost    INT NOT NULL,
  lo_tax           INT NOT NULL,
  lo_commitdate    INT NOT NULL,
  lo_shipmode      CHAR(10) NOT NULL
) WITH BLOCKPROPERTIES (
  TYPE columnstore,
  SORT lo_orderkey,
  BLOCKSIZEMB 4);
--) WITH BLOCKPROPERTIES (
--  TYPE compressed_columnstore,
--  SORT lo_orderkey,
--  COMPRESS ALL,
--  BLOCKSIZEMB 4);
-- CREATE INDEX sma_lo ON lineorder USING SMA;

CREATE TABLE part (
  p_partkey   INT NOT NULL,
  p_name      VARCHAR(22) NOT NULL,
  p_mfgr      CHAR(6) NOT NULL,
  p_category  CHAR(7) NOT NULL,
  p_brand1    CHAR(9) NOT NULL,
  p_color     VARCHAR(11) NOT NULL,
  p_type      VARCHAR(25) NOT NULL,
  p_size      INT NOT NULL,
  p_container CHAR(10) NOT NULL
) WITH BLOCKPROPERTIES (
  TYPE split_rowstore,
  BLOCKSIZEMB 4);
-- CREATE INDEX sma_p ON part USING SMA;

CREATE TABLE supplier (
  s_suppkey INT NOT NULL,
  s_name    CHAR(25) NOT NULL,
  s_address VARCHAR(25) NOT NULL,
  s_city    CHAR(10) NOT NULL,
  s_nation  CHAR(15) NOT NULL,
  s_region  CHAR(12) NOT NULL,
  s_phone   CHAR(15) NOT NULL
) WITH BLOCKPROPERTIES (
  TYPE split_rowstore,
  BLOCKSIZEMB 4);
-- CREATE INDEX sma_s ON supplier USING SMA;

CREATE TABLE customer (
  c_custkey    INT NOT NULL,
  c_name       VARCHAR(25) NOT NULL,
  c_address    VARCHAR(25) NOT NULL,
  c_city       CHAR(10) NOT NULL,
  c_nation     CHAR(15) NOT NULL,
  c_region     CHAR(12) NOT NULL,
  c_phone      CHAR(15) NOT NULL,
  c_mktsegment CHAR(10) NOT NULL
) WITH BLOCKPROPERTIES (
  TYPE split_rowstore,
  BLOCKSIZEMB 4);
-- CREATE INDEX sma_c ON customer USING SMA;

CREATE TABLE ddate (
  d_datekey          INT NOT NULL,
  d_date             CHAR(18) NOT NULL,
  d_dayofweek        CHAR(9) NOT NULL,
  d_month            CHAR(9) NOT NULL,
  d_year             INT NOT NULL,
  d_yearmonthnum     INT NOT NULL,
  d_yearmonth        CHAR(7) NOT NULL,
  d_daynuminweek     INT NOT NULL,
  d_daynuminmonth    INT NOT NULL,
  d_daynuminyear     INT NOT NULL,
  d_monthnuminyear   INT NOT NULL,
  d_weeknuminyear    INT NOT NULL,
  d_sellingseason    VARCHAR(12) NOT NULL,
  d_lastdayinweekfl  INT NOT NULL,
  d_lastdayinmonthfl INT NOT NULL,
  d_holidayfl        INT NOT NULL,
  d_weekdayfl        INT NOT NULL
) WITH BLOCKPROPERTIES (
  TYPE split_rowstore,
  BLOCKSIZEMB 4);
-- CREATE INDEX sma_d ON ddate USING SMA;

