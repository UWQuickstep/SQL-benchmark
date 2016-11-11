/* SSB.scala */
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
import scala.collection.mutable.ArrayBuffer

case class RunConfig1(
    ssb_path: String = null,
    filter: Option[String] = None,
    iterations: Int = 5,
    cache_tables: Boolean = false,
    baseline: Option[Long] = None,
    query_list:Seq[Int] = Seq(),
    partitions: String = "1")

case class WideTable (
    lo_orderkey: Int,
    lo_linenumber: Int,
    lo_custkey: Int,
    lo_partkey: Int,
    lo_suppkey: Int,
    lo_orderdate: Int,
    lo_orderpriority:String,
    lo_shippriority:String,
    lo_quantity: Int,
    lo_extendedprice: Int,
    lo_ordtotalprice: Int,
    lo_discount: Int,
    lo_revenue: Int,
    lo_supplycost: Int,
    lo_tax: Int,
    lo_commitdate: Int,
    lo_shipmode: String,
    p_partkey: Int,
    p_name:String,
    p_mfgr: String,
    p_category : String,
    p_brand1 : String,
    p_color : String,
    p_type : String,
    p_size: Int,
    p_container  : String ,
    s_suppkey: Int,
    s_name  : String ,
    s_address  : String ,
    s_city  : String ,
    s_nation  : String ,
    s_region  : String ,
    s_phone  : String ,
    c_custkey: Int,
    c_name  : String ,
    c_address  : String,
    c_city  : String ,
    c_nation  : String ,
    c_region  : String ,
    c_phone  : String ,
    c_mktsegment  : String ,
    d_datekey: Int,
    d_date  : String ,
    d_dayofweek  : String ,
    d_month  : String ,
    d_year: Int,
    d_yearmonthnum: Int,
    d_yearmonth  : String ,
    d_daynuminweek: Int,
    d_daynuminmonth: Int,
    d_daynuminyear: Int,
    d_monthnuminyear: Int,
    d_weeknuminyear: Int,
    d_sellingseason  : String ,
    d_lastdayinweekfl: Int,
    d_lastdayinmonthfl: Int,
    d_holidayfl: Int,
    d_weekdayfl: Int)

object SSBWideTable {
  def main(args: Array[String]) {

    val parser = new scopt.OptionParser[RunConfig1]("spark-sql-perf") {
      head("SSB BenchMark on Spark", "0.2.0")
      opt[String]('d', "ssb_data").action { (x, c) => c.copy(ssb_path = x) }
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
      opt[Seq[Int]]('q',"queries")
          .action{(x, c) => c.copy(query_list = x)}
          .text("Queries to run")
          .valueName("1,2,3 .....")
      help("help")
        .text("prints this usage text")
        }

        parser.parse(args, RunConfig1()) match {
          case Some(config) =>
            run(config)
          case None =>
            System.exit(1)
        }

    def run(config: RunConfig1) {
        val ssb_path = config.ssb_path
        val file_name = Paths.get(ssb_path).getFileName()
        val conf = new SparkConf().setAppName(file_name.toString())
        val sc = new SparkContext(conf)
        val sqlContext : org.apache.spark.sql.SQLContext = new org.apache.spark.sql.SQLContext(sc)
        var query_list_name = "Queries"
        import sqlContext.implicits._
        // setting shuffle partitions to 1
        println("Setting the shuffle partitions to: "+config.partitions)
        sqlContext.setConf("spark.sql.shuffle.partitions", config.partitions)

        var table_names = Array("widetable")
        var query_list = config.query_list
        var iterations = config.iterations
// for (i <- 0 until table_names.length) {
        //     val lineorder =  sc.textFile(f.getPath()).map(_.split("\\|")).map(p => LineOrder(p(0).trim.toInt, p(1).trim.toInt,p(2).trim.toInt,p(3).trim.toInt,p(4).trim.toInt,p(5).trim.toInt,p(6),p(7),p(8).trim.toInt,p(9).trim.toInt,p(10).trim.toInt,p(11).trim.toInt,p(12).trim.toInt,p(13).trim.toInt,p(14).trim.toInt,p(15).trim.toInt,p(16))).toDF()
        // }
        val file_load_timer_writer = new PrintWriter(new File("load_times.csv" ))
        val f: java.io.File = new File(ssb_path ,"widetable.tbl")

        var start = System.currentTimeMillis()
        val widetable =  sc.textFile(f.getPath()).map(_.split("\\|")).map(p =>
                                     WideTable(
                                      p(0).trim.toInt,
                                      p(1).trim.toInt,
                                      p(2).trim.toInt,
                                      p(3).trim.toInt,
                                      p(4).trim.toInt,
                                      p(5).trim.toInt,
                                      p(6).trim,
                                      p(7).trim,
                                      p(8).trim.toInt,
                                      p(9).trim.toInt,
                                      p(10).trim.toInt,
                                      p(11).trim.toInt,
                                      p(12).trim.toInt,
                                      p(13).trim.toInt,
                                      p(14).trim.toInt,
                                      p(15).trim.toInt,
                                      p(16).trim,
                                      p(17).trim.toInt,
                                      p(18).trim,
                                      p(19).trim,
                                      p(20).trim,
                                      p(21).trim,
                                      p(22).trim,
                                      p(23).trim,
                                      p(24).trim.toInt,
                                      p(25).trim,
                                      p(26).trim.toInt,
                                      p(27).trim,
                                      p(28).trim,
                                      p(29).trim,
                                      p(30).trim,
                                      p(31).trim,
                                      p(32).trim,
                                      p(33).trim.toInt,
                                      p(34).trim,
                                      p(35).trim,
                                      p(36).trim,
                                      p(37).trim,
                                      p(38).trim,
                                      p(39).trim,
                                      p(40).trim,
                                      p(41).trim.toInt,
                                      p(42).trim,
                                      p(43).trim,
                                      p(44).trim,
                                      p(45).trim.toInt,
                                      p(46).trim.toInt,
                                      p(47).trim,
                                      p(48).trim.toInt,
                                      p(49).trim.toInt,
                                      p(50).trim.toInt,
                                      p(51).trim.toInt,
                                      p(52).trim.toInt,
                                      p(53).trim,
                                      p(54).trim.toInt,
                                      p(55).trim.toInt,
                                      p(56).trim.toInt,
                                      p(57).trim.toInt)
                                     ).toDF()

        widetable.registerTempTable("widetable")
        var end = System.currentTimeMillis()
        file_load_timer_writer.write("widetable,"+((end-start)))
        //widetable.write.parquet("/newDisk1/spark_storage/widetable.parquet")

        file_load_timer_writer.close()

        if (config.cache_tables) {
            for (i <- 0 until table_names.length) {
              sqlContext.cacheTable(table_names(i))
              sqlContext.sql("SELECT * FROM "+table_names(i)).count();
            }
         }
        val Q1="select sum(lo_extendedprice*lo_discount) as revenue from widetable where d_year = 1993 and lo_discount between 1 and 3 and lo_quantity < 25"
        val Q2="select sum(lo_extendedprice*lo_discount) as revenue from widetable where d_yearmonthnum = 199401 and lo_discount between 4 and 6 and lo_quantity between 26 and 35"
        val Q3="select sum(lo_extendedprice*lo_discount) as revenue from widetable where d_weeknuminyear = 6 and d_year = 1994 and lo_discount between 5 and 7 and lo_quantity between 36 and 40"
        val Q4="select sum(lo_revenue), d_year, p_brand1 from widetable where p_category = 'MFGR#12' and s_region = 'AMERICA' group by d_year, p_brand1 order by d_year, p_brand1"
        val Q5="select sum(lo_revenue), d_year, p_brand1 from widetable where p_brand1 between 'MFGR#2221' and 'MFGR#2228' and s_region = 'ASIA' group by d_year, p_brand1 order by d_year, p_brand1"
        val Q6="select sum(lo_revenue), d_year, p_brand1 from widetable where p_brand1 = 'MFGR#2221' and s_region = 'EUROPE' group by d_year, p_brand1 order by d_year, p_brand1"
        val Q7="select c_nation, s_nation, d_year, sum(lo_revenue) as revenue from widetable where c_region = 'ASIA' and s_region = 'ASIA' and d_year >= 1992 and d_year <= 1997 group by c_nation, s_nation, d_year order by d_year asc, revenue desc"
        val Q8="select c_city, s_city, d_year, sum(lo_revenue) as revenue from widetable where c_nation = 'UNITED STATES' and s_nation = 'UNITED STATES' and d_year >= 1992 and d_year <= 1997 group by c_city, s_city, d_year order by d_year asc, revenue desc"
        val Q9="select c_city, s_city, d_year, sum(lo_revenue) as revenue from widetable where (c_city='UNITED KI1' or c_city='UNITED KI5') and (s_city='UNITED KI1' or s_city='UNITED KI5') and d_year >= 1992 and d_year <= 1997 group by c_city, s_city, d_year order by d_year asc, revenue desc"
        val Q10="select c_city, s_city, d_year, sum(lo_revenue) as revenue from widetable where (c_city='UNITED KI1' or c_city='UNITED KI5') and (s_city='UNITED KI1' or s_city='UNITED KI5') and d_yearmonth = 'Dec1997' group by c_city, s_city, d_year order by d_year asc, revenue desc"
        val Q11="select d_year, c_nation, sum(lo_revenue-lo_supplycost) as profit1 from widetable where c_region = 'AMERICA' and s_region = 'AMERICA'and (p_mfgr = 'MFGR#1' or p_mfgr ='MFGR#2') group by d_year, c_nation order by d_year, c_nation"
        val Q12="select d_year, s_nation, p_category, sum(lo_revenue-lo_supplycost) as profit1 from widetable where c_region = 'AMERICA' and s_region = 'AMERICA' and (d_year = 1997 or d_year = 1998) and (p_mfgr = 'MFGR#1' or p_mfgr = 'MFGR#2') group by d_year, s_nation, p_category order by d_year, s_nation, p_category"
        val Q13="select d_year, s_city, p_brand1, sum(lo_revenue-lo_supplycost) as profit1 from widetable where c_region = 'AMERICA' and s_nation = 'UNITED STATES' and (d_year = 1997 or d_year = 1998) and p_category = 'MFGR#14' group by d_year, s_city, p_brand1 order by d_year, s_city, p_brand1"

        var queries = ArrayBuffer[String](Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13)
        var query_array= ArrayBuffer[String]()
        if (query_list.length == 0) {
            query_array = queries
            query_list_name=query_list_name+"+all"
        } else {
           for (iter_count <-0 until query_list.length){
             query_array += queries(query_list(iter_count)-1)
             query_list_name = query_list_name +"_"+query_list(iter_count)
          }
        }
        // Array to store timing results
        var times_array = ofDim[Long](iterations,query_array.length)
        // Writer to write the results to file
        val writer = new PrintWriter(new File(file_name+"_"+query_list_name+"_result.csv" ))
        for (iter_count <- 0 until  iterations) {
          writer.write(""+(iter_count+1))
          for (i <- 0 until query_array.length) {
            writer.write(",")
            var start = System.currentTimeMillis()
            val q_rdd = sqlContext.sql(query_array(i))
            println("Result Count:"+q_rdd.count())
            var end = System.currentTimeMillis()
            times_array(iter_count)(i) = end - start
            writer.write((end - start)+"")
            System.out.println("Execution Time:"+ times_array(iter_count)(i)/1000)
          }
        writer.write("\n")
        }
        writer.close()
      }
   }
}
