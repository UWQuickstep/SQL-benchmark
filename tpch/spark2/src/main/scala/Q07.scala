package main.scala

import org.apache.spark.SparkContext
import org.apache.spark.sql.SQLContext
import org.apache.spark.sql.DataFrame

class Q07 extends TPCHQuery {
  override def run(sparkContext: SparkContext, db: TPCHDatabase): DataFrame = {
    val sqlContext = db.sqlContext
    import sqlContext.implicits._

    val query_07 = s"""
select
	shipping.supp_nation,
	shipping.cust_nation,
	shipping.l_year,
	sum(shipping.volume) as revenue
from
	(
		select
			n1.n_name as supp_nation,
			n2.n_name as cust_nation,
			extract(year from l_shipdate) as l_year,
			l_extendedprice * (1 - l_discount) as volume
		from
			supplier,
			lineitem,
			orders,
			customer,
			nation n1,
			nation n2
		where
			s_suppkey = l_suppkey
			and o_orderkey = l_orderkey
			and c_custkey = o_custkey
			and s_nationkey = n1.n_nationkey
			and c_nationkey = n2.n_nationkey
			and (
				(n1.n_name = 'FRANCE' and n2.n_name = 'GERMANY')
				or (n1.n_name = 'GERMANY' and n2.n_name = 'FRANCE')
			)
			and l_shipdate between date '1995-01-01' and date '1996-12-31'
	) shipping
group by
	shipping.supp_nation,
	shipping.cust_nation,
	shipping.l_year
order by
	shipping.supp_nation,
	shipping.cust_nation,
	shipping.l_year
"""
    return sqlContext.sql(query_07)
  }
}
