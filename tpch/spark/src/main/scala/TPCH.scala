/* TPCH.scala */
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf
import org.apache.spark.sql.SQLContext
import org.apache.spark.sql.SQLContext._
import java.io._
import java.io.File
import Array._
import java.nio.file.Paths
import java.nio.file.Path

case class RunConfig(
    data_path: String = null,
    filter: Option[String] = None,
    iterations: Int = 5,
    cache_tables: Boolean = false,
    baseline: Option[Long] = None,
    partitions: String = "1")

case class Region (
  r_regionkey:Int,
  r_name:String,
  r_comment:String
)

case class Nation (
  n_nationkey:Int,
  n_name:String,
  n_regionkey:Int,
  n_comment:String
)

case class Supplier (
  s_suppkey:Int,
  s_name:String,
  s_address:String,
  s_nationkey:Int,
  s_phone:String,
  s_acctbal:Double,
  s_comment:String
)

case class Customer (
  c_custkey:Int,
  c_name:String,
  c_address:String,
  c_nationkey:Int,
  c_phone:String,
  c_acctbal:Double,
  c_mktsegment:String,
  c_comment:String
)

case class Part (
  p_partkey:Int,
  p_name:String,
  p_mfgr:String,
  p_brand:String,
  p_type:String,
  p_size:Int,
  p_container:String,
  p_retailprice:Double,
  p_comment:String
)

case class Partsupp (
  ps_partkey:Int,
  ps_suppkey:Int,
  ps_availqty:Int,
  ps_supplycost:Double,
  ps_comment:String
)
case class Orders (
  o_orderkey:Int,
  o_custkey:Int,
  o_orderstatus:String,
  o_totalprice:Double,
  o_orderSTRING:String,
  o_orderpriority:String,
  o_clerk:String,
  o_shippriority:Int,
  o_comment:String
)

case class Lineitem (
  l_orderkey:Int,
  l_partkey:Int,
  l_suppkey:Int,
  l_linenumber:Int,
  l_quantity:Double,
  l_extendedprice:Double,
  l_discount:Double,
  l_tax:Double,
  l_returnflag:String,
  l_linestatus:String,
  l_shipSTRING:String,
  l_commitSTRING:String,
  l_receiptSTRING:String,
  l_shipinstruct:String,
  l_shipmode:String,
  l_comment:String
)
object TPCH {
  def main(args: Array[String]) {

    val parser = new scopt.OptionParser[RunConfig]("spark-sql-perf") {
      head("TPCH BenchMark on Spark", "0.2.0")
      opt[String]('d', "data_path").action { (x, c) => c.copy(data_path = x) }
        .text("path to the tbl files")
        .required()
      opt[String]('f', "filter")
        .action((x, c) => c.copy(filter = Some(x)))
        .text("a filter on the name of the queries to run")
      opt[Int]('i', "iterations")
        .action((x, c) => c.copy(iterations = x))
        .text("the number of iterations to run")
      opt[String]('p', "partitions")
        .action((x, c) => c.copy(partitions = x))
        .text("the number of reducers to be used by spark")
      opt[Boolean]('h', "cache")
          .action((x, c) => c.copy(cache_tables = x))
          .text("Cache tables")
      help("help")
        .text("prints this usage text")
        }

        parser.parse(args, RunConfig()) match {
          case Some(config) =>
            run(config)
          case None =>
            System.exit(1)
        }

    def run(config: RunConfig) {
        val data_path = config.data_path
        val file_name = Paths.get(data_path).getFileName()
        val conf = new SparkConf().setAppName(file_name.toString())
        val sc = new SparkContext(conf)
        val sqlContext : org.apache.spark.sql.SQLContext = new org.apache.spark.sql.SQLContext(sc)

        import sqlContext.implicits._
        // setting shuffle partitions to 1
        println("Setting the shuffle partitions to: "+config.partitions)
        sqlContext.setConf("spark.sql.shuffle.partitions", config.partitions)

        var table_names = Array("lineitem", "part", "supplier", "customer", "partsupp", "nation", "region", "orders")
        var iterations = config.iterations

        var f: java.io.File = new File(data_path ,"region.tbl")
        val region =  sc.textFile(f.getPath()).map(_.split("\\|")).map(p => Region(p(0).trim.toInt, p(1).trim, p(2).trim)).toDF()

        f = new File(data_path ,"nation.tbl")
        val nation =  sc.textFile(f.getPath()).map(_.split("\\|")).map(p => Nation(p(0).trim.toInt, p(1).trim, p(2).trim.toInt,p(3))).toDF()

        f = new File(data_path ,"supplier.tbl")
        val supplier =  sc.textFile(f.getPath()).map(_.split("\\|")).map(p => Supplier(p(0).trim.toInt, p(1).trim, p(2).trim, p(3).trim.toInt,p(4).trim,p(5).trim.toDouble,p(6).trim) ).toDF()

        f = new File(data_path ,"customer.tbl")
        val customer =  sc.textFile(f.getPath()).map(_.split("\\|")).map(p => Customer(p(0).trim.toInt, p(1).trim, p(2).trim,p(3).trim.toInt,p(4).trim,p(5).trim.toDouble,p(6).trim,p(7).trim) ).toDF()

        f = new File(data_path ,"part.tbl")
        val part =  sc.textFile(f.getPath()).map(_.split("\\|")).map(p => Part(p(0).trim.toInt, p(1).trim, p(2).trim,p(3).trim,p(4).trim,p(5).trim.toInt,p(6).trim,p(7).trim.toDouble,p(8).trim )).toDF()

        f = new File(data_path ,"partsupp.tbl")
        val partsupp =  sc.textFile(f.getPath()).map(_.split("\\|")).map(p => Partsupp(p(0).trim.toInt, p(1).trim.toInt, p(2).trim.toInt,p(3).trim.toDouble,p(4).trim )).toDF()

        f = new File(data_path ,"orders.tbl")
        val orders =  sc.textFile(f.getPath()).map(_.split("\\|")).map(p => Orders(p(0).trim.toInt, p(1).trim.toInt, p(2).trim,p(3).trim.toDouble,p(4).trim,p(5).trim,p(6).trim,p(7).trim.toInt,p(8).trim) ).toDF()

        f = new File(data_path ,"lineitem.tbl")
        val lineitem =  sc.textFile(f.getPath()).map(_.split("\\|")).map(p => Lineitem(p(0).trim.toInt, p(1).trim.toInt, p(2).trim.toInt,p(3).trim.toInt,p(4).trim.toDouble,p(5).trim.toDouble,p(6).trim.toDouble,p(7).trim.toDouble,p(8).trim,p(9).trim,p(10).trim,p(11).trim,p(12).trim,p(13).trim,p(14).trim,p(15).trim )).toDF()

        nation.registerTempTable("nation")
        region.registerTempTable("region")
        supplier.registerTempTable("supplier")
        customer.registerTempTable("customer")
        part.registerTempTable("part")
        partsupp.registerTempTable("partsupp")
        orders.registerTempTable("orders")
        lineitem.registerTempTable("lineitem")

        if (config.cache_tables) {
            for (i <- 0 until table_names.length) {
              sqlContext.cacheTable(table_names(i))
              sqlContext.sql("SELECT * FROM "+table_names(i)).count();
            }
         }
        val Q1=""
        val Q2=""
        val Q3=""
        val Q4=""
        val Q5=""
        val Q6=""
        val Q7=""
        val Q8=""
        val Q9=""
        val Q10=""
        val Q11=""
        val Q12=""
        val Q13="""select cntrycode,count(*)  numcust,sum(c_acctbal)  totacctbal
                  from (select substr(c_phone,1,2)  cntrycode,c_acctbal from
                  customer where substr(c_phone,1,2) in
                  ('13', '31', '23', '29', '30', '18', '17')
                  and c_acctbal > (select avg(c_acctbal) from customer
                  where c_acctbal > 0.00 and substr(c_phone ,1 ,2) in
                  ('13', '31', '23', '29', '30', '18', '17'))
                  and not exists (select * from orders where o_custkey = c_custkey)
                  ) custsale group by cntrycode order by cntrycode;"""

        var query_array = Array(Q13)
        // Array to store timing results
        var times_array = ofDim[Long](iterations,query_array.length)
        // Writer to write the results to file
        val writer = new PrintWriter(new File(file_name+"_result.csv" ))
        for (iter_count <- 0 until  iterations) {
          writer.write(""+(iter_count+1))
          for (i <- 0 until query_array.length) {
            writer.write(",")
            val start = System.currentTimeMillis()
            val q_rdd = sqlContext.sql(query_array(i))
            q_rdd.count()
            val end = System.currentTimeMillis()
            times_array(iter_count)(i) = end - start
            writer.write((end - start)+"")
            System.out.println( times_array(iter_count)(i)/1000)
          }
        writer.write("\n")
        }
        writer.close()
      }
   }
}
