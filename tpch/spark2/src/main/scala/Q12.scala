package main.scala

import org.apache.spark.SparkContext
import org.apache.spark.sql.SQLContext
import org.apache.spark.sql.DataFrame

class Q12 extends TPCHQuery {
  override def run(sparkContext: SparkContext, db: TPCHDatabase): DataFrame = {
    val sqlContext = db.sqlContext
    import sqlContext.implicits._

    val query_12 = s"""
select
	l_shipmode,
	sum(case
		when o_orderpriority = '1-URGENT' or o_orderpriority = '2-HIGH'
		then 1
		else 0
	end) as high_line_count,
	sum(case
		when o_orderpriority <> '1-URGENT' or o_orderpriority <> '2-HIGH'
		then 1
		else 0
	end) as low_line_count
from
	orders,
	lineitem
where
	o_orderkey = l_orderkey
	and (l_shipmode = 'MAIL' or l_shipmode = 'SHIP')
	and l_commitdate < l_receiptdate
	and l_shipdate < l_commitdate
	and l_receiptdate >= date '1994-01-01'
	and l_receiptdate < date '1994-01-01' + interval '1' year
group by
	l_shipmode
order by
	l_shipmode
"""
    return sqlContext.sql(query_12)
  }
}