package main.scala

import org.apache.spark.SparkContext

case class Region (
  r_regionkey  : Int,
  r_name       : String,
  r_comment    : String
)

case class Nation (
  n_nationkey  : Int,
  n_name       : String,
  n_regionkey  : Int,
  n_comment    : String
)

case class Supplier (
  s_suppkey    : Int,
  s_name       : String,
  s_address    : String,
  s_nationkey  : Int,
  s_phone      : String,
  s_acctbal    : Double,
  s_comment    : String
)

case class Customer (
  c_custkey    : Int,
  c_name       : String,
  c_address    : String,
  c_nationkey  : Int,
  c_phone      : String,
  c_acctbal    : Double,
  c_mktsegment : String,
  c_comment    : String
)

case class Part (
  p_partkey    : Int,
  p_name       : String,
  p_mfgr       : String,
  p_brand      : String,
  p_type       : String,
  p_size       : Int,
  p_container  : String,
  p_retailprice: Double,
  p_comment    : String
)

case class Partsupp (
  ps_partkey      : Int,
  ps_suppkey      : Int,
  ps_availqty     : Int,
  ps_supplycost   : Double,
  ps_comment      : String
)

case class Orders (
  o_orderkey      : Int,
  o_custkey       : Int,
  o_orderstatus   : String,
  o_totalprice    : Double,
  o_orderdate     : String,
  o_orderpriority : String,
  o_clerk         : String,
  o_shippriority  : Int,
  o_comment       : String
)

case class Lineitem (
  l_orderkey      : Int,
  l_partkey       : Int,
  l_suppkey       : Int,
  l_linenumber    : Int,
  l_quantity      : Double,
  l_extendedprice : Double,
  l_discount      : Double,
  l_tax           : Double,
  l_returnflag    : String,
  l_linestatus    : String,
  l_shipstring    : String,
  l_commitdate    : String,
  l_receiptdate   : String,
  l_shipinstruct  : String,
  l_shipmode      : String,
  l_comment       : String
)

class TPCHDatabase(sparkContext: SparkContext, tablesDirectory: String) {
  val sqlContext = new org.apache.spark.sql.SQLContext(sc)
  import sqlContext.implicits._

  val region_tbl   = tablesDirectory + "/" + "region.tbl"
  val nation_tbl   = tablesDirectory + "/" + "nation.tbl"
  val supplier_tbl = tablesDirectory + "/" + "supplier.tbl"
  val customer_tbl = tablesDirectory + "/" + "customer.tbl"
  val part_tbl     = tablesDirectory + "/" + "part.tbl"
  val partsupp_tbl = tablesDirectory + "/" + "partsupp.tbl"
  val orders_tbl   = tablesDirectory + "/" + "orders.tbl"
  val lineitem_tbl = tablesDirectory + "/" + "lineitem.tbl"

  val tables = Map(
    "region"   -> sc.read.csv(region_tbl, sep='|', header=false).as[Region],
    "nation"   -> sc.read.csv(nation_tbl, sep='|', header=false).as[Nation],
    "supplier" -> sc.read.csv(supplier_tbl, sep='|', header=false).as[Supplier],
    "customer" -> sc.read.csv(customer_tbl, sep='|', header=false).as[Customer],
    "part"     -> sc.read.csv(part_tbl, sep='|', header=false).as[Part],
    "partsupp" -> sc.read.csv(partsupp_tbl, sep='|', header=false).as[Partsupp],
    "orders"   -> sc.read.csv(orders_tbl, sep='|', header=false).as[Orders],
    "lineitem" -> sc.read.csv(lineitem_tbl, sep='|', header=false).as[Lineitem]
  )

  val region   = tables("region")
  val nation   = tables("nation")
  val supplier = tables("supplier")
  val customer = tables("customer")
  val part     = tables("part")
  val partsupp = tables("partsupp")
  val orders   = tables("orders")
  val lineitem = tables("lineitem")

  tables.foreach {
    case (table_name, table_ds) => table_ds.createOrReplaceTempView(table_name)
  }

}
