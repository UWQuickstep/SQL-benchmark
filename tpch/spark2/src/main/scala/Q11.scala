package main.scala

import org.apache.spark.SparkContext
import org.apache.spark.sql.SQLContext
import org.apache.spark.sql.DataFrame

class Q11 extends TPCHQuery {
  override def run(sparkContext: SparkContext, db: TPCHDatabase): DataFrame = {
    val sqlContext = db.sqlContext
    import sqlContext.implicits._

    val query_11 = s"""
select
	ps_partkey,
	sum(ps_supplycost * ps_availqty) as value
from
	partsupp,
	supplier,
	nation
where
	ps_suppkey = s_suppkey
	and s_nationkey = n_nationkey
	and n_name = 'GERMANY'
group by
	ps_partkey
having
	sum(ps_supplycost * ps_availqty) >
	(
		select
			sum(ps_supplycost * ps_availqty) * 0.00000100000000
		from
			partsupp,
			supplier,
			nation
		where
			ps_suppkey = s_suppkey
			and s_nationkey = n_nationkey
			and n_name = 'GERMANY'
	)
order by
	value desc
"""
    return sqlContext.sql(query_11)
  }
}
