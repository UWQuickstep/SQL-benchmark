package main.scala

import org.apache.spark.SparkContext
import org.apache.spark.sql.SQLContext
import org.apache.spark.sql.DataFrame

class Q04 extends TPCHQuery {
  override def run(sparkContext: SparkContext): DataFrame = {
    val sqlContext = new SQLContext(sparkContext)
    import sqlContext.implicits._

    val query_04 = s"""
select
	o_orderpriority,
	count(*) as order_count
from
	orders
where
	o_orderdate >= date '1993-07-01'
	and o_orderdate < date '1993-07-01' + interval '3' month
	and exists (
		select
			*
		from
			lineitem
		where
			l_orderkey = o_orderkey
			and l_commitdate < l_receiptdate
	)
group by
	o_orderpriority
order by
	o_orderpriority
"""
    return sqlContext.sql(query_04)
  }
}
