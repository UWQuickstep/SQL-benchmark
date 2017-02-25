package main.scala

import org.apache.spark.SparkContext
import org.apache.spark.sql.SQLContext
import org.apache.spark.sql.DataFrame

//import org.apache.spark.sql.Dataset
//import org.apache.spark.sql.functions._

class Q01 extends TPCHQuery {
  override def run(sparkContext: SparkContext, db: TPCHDatabase): DataFrame = {
    //val sqlContext = new SQLContext(sparkContext)
    val sqlContext = db.sqlContext
    import sqlContext.implicits._
    //import db._

    val query_01 = s"""
select
	l_returnflag,
	l_linestatus,
	sum(l_quantity) as sum_qty,
	sum(l_extendedprice) as sum_base_price,
	sum(l_extendedprice * (1 - l_discount)) as sum_disc_price,
	sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)) as sum_charge,
	avg(l_quantity) as avg_qty,
	avg(l_extendedprice) as avg_price,
	avg(l_discount) as avg_disc,
	count(*) as count_order
from
	lineitem
where
	l_shipdate <= date '1998-09-01'
group by
	l_returnflag,
	l_linestatus
order by
	l_returnflag,
	l_linestatus
"""
    return sqlContext.sql(query_01)
  }
}
