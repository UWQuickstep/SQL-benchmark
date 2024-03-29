package main.scala

import org.apache.spark.SparkContext
import org.apache.spark.sql._

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
  l_shipdate      : String,
  l_commitdate    : String,
  l_receiptdate   : String,
  l_shipinstruct  : String,
  l_shipmode      : String,
  l_comment       : String
)

class TPCHDatabase(sparkContext: SparkContext, tablesDirectory: String) extends java.io.Serializable {
  val sqlContext = new org.apache.spark.sql.SQLContext(sparkContext)
  import sqlContext.implicits._

  val region_tbl   = tablesDirectory + "/" + "region.tbl"
  val nation_tbl   = tablesDirectory + "/" + "nation.tbl"
  val supplier_tbl = tablesDirectory + "/" + "supplier.tbl"
  val customer_tbl = tablesDirectory + "/" + "customer.tbl"
  val part_tbl     = tablesDirectory + "/" + "part.tbl"
  val partsupp_tbl = tablesDirectory + "/" + "partsupp.tbl"
  val orders_tbl   = tablesDirectory + "/" + "orders.tbl"
  val lineitem_tbl = tablesDirectory + "/" + "lineitem.tbl"

  val region   : Dataset[Region] = sqlContext.read.option("sep", "|").option("header", false)
    .csv(region_tbl).map(row => parseRegion(row))
  val nation   : Dataset[Nation] = sqlContext.read.option("sep", "|").option("header", false)
    .csv(nation_tbl).map(row => parseNation(row))
  val supplier : Dataset[Supplier] = sqlContext.read.option("sep", "|").option("header", false)
    .csv(supplier_tbl).map(row => parseSupplier(row))
  val customer : Dataset[Customer] = sqlContext.read.option("sep", "|").option("header", false)
    .csv(customer_tbl).map(row => parseCustomer(row))
  val part     : Dataset[Part] = sqlContext.read.option("sep", "|").option("header", false)
    .csv(part_tbl).map(row => parsePart(row))
  val partsupp : Dataset[Partsupp] = sqlContext.read.option("sep", "|").option("header", false)
    .csv(partsupp_tbl).map(row => parsePartsupp(row))
  val orders   : Dataset[Orders] = sqlContext.read.option("sep", "|").option("header", false)
    .csv(orders_tbl).map(row => parseOrders(row))
  val lineitem : Dataset[Lineitem] = sqlContext.read.option("sep", "|").option("header", false)
    .csv(lineitem_tbl).map(row => parseLineitem(row))

  region.cache()
  nation.cache()
  supplier.cache()
  customer.cache()
  part.cache()
  partsupp.cache()
  orders.cache()
  lineitem.cache()

  region.createOrReplaceTempView("region")
  nation.createOrReplaceTempView("nation")
  supplier.createOrReplaceTempView("supplier")
  customer.createOrReplaceTempView("customer")
  part.createOrReplaceTempView("part")
  partsupp.createOrReplaceTempView("partsupp")
  orders.createOrReplaceTempView("orders")
  lineitem.createOrReplaceTempView("lineitem")

  def parseRegion(row: Row): Region = {
    return Region(
      row.getString(0).toInt,
      row.getString(1),
      row.getString(2)
    )
  }

  def parseNation(row: Row): Nation = {
    return Nation(
      row.getString(0).toInt,
      row.getString(1),
      row.getString(2).toInt,
      row.getString(3)
    )
  }

  def parseSupplier(row: Row): Supplier = {
    return Supplier(
      row.getString(0).toInt,
      row.getString(1),
      row.getString(2),
      row.getString(3).toInt,
      row.getString(4),
      row.getString(5).toDouble,
      row.getString(6)
    )
  }

  def parseCustomer(row: Row): Customer = {
    return Customer(
      row.getString(0).toInt,
      row.getString(1),
      row.getString(2),
      row.getString(3).toInt,
      row.getString(4),
      row.getString(5).toDouble,
      row.getString(6),
      row.getString(7)
    )
  }

  def parsePart(row: Row): Part = {
    return Part(
      row.getString(0).toInt,
      row.getString(1),
      row.getString(2),
      row.getString(3),
      row.getString(4),
      row.getString(5).toInt,
      row.getString(6),
      row.getString(7).toDouble,
      row.getString(8)
    )
  }

  def parsePartsupp(row: Row): Partsupp = {
    return Partsupp(
      row.getString(0).toInt,
      row.getString(1).toInt,
      row.getString(2).toInt,
      row.getString(3).toDouble,
      row.getString(4)
    )
  }

  def parseOrders(row: Row): Orders = {
    return Orders(
      row.getString(0).toInt,
      row.getString(1).toInt,
      row.getString(2),
      row.getString(3).toDouble,
      row.getString(4),
      row.getString(5),
      row.getString(6),
      row.getString(7).toInt,
      row.getString(8)
    )
  }

  def parseLineitem(row: Row): Lineitem = {
    return Lineitem(
      row.getString(0).toInt,
      row.getString(1).toInt,
      row.getString(2).toInt,
      row.getString(3).toInt,
      row.getString(4).toDouble,
      row.getString(5).toDouble,
      row.getString(6).toDouble,
      row.getString(7).toDouble,
      row.getString(8),
      row.getString(9),
      row.getString(10),
      row.getString(11),
      row.getString(12),
      row.getString(13),
      row.getString(14),
      row.getString(15)
    )
  }
}
