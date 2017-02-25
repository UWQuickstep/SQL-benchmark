package main.scala

import org.apache.spark.SparkContext
import org.apache.spark.SparkConf
import org.apache.spark.sql._

case class Settings (
  dataPath: String,
  queries  : List[Int],
  repeat   : Int
)

abstract class TPCHQuery {
  def getName(): String
  def run(sparkContext: SparkContext, database: TPCHDatabase): Dataset
}

object TPCHQuery {
  def main(args: Array[String]) {
    val parser = new scopt.OptionParser[RunConfig]("spark-sql-tpch") {
      head("TPCH Benchmark for Spark SQL 2.1.0")
      opt[String]("d", "data_path").action { (x, c) => c.copy(dataPath = x) }
        .text("Path to the .tbl files")
        .required()
      opt[Seq[Int]]("q", "queries").valueName("1,2,...").action { (x, c) => c.copy(queries = x)}
        .text("List of queries to run")
        .required()
      opt[Int]("r", "repeat").action { (x, c) => c.copy(repeat = x) }
        .text("Number of repeats for each query")
    }

    parser.parse(args, Settings()) match {
      case Some(settings) => {}
      case None => {
        println("Bad settings!")
        System.exit(1)
      }
    }

    val path = settings.dataPath
    val repeat = settings.repeat
    val queries: List[Int] = settings.queries

    val config = new SparkConf().setAppName("TPCH Benchmark")
    val sparkContext = new SparkContext(config)

    val database = new TPCHDatabase(sparkContext, path)

    runQueries(sparkContext, database, queries, repeat)
  }

  def runQueries(sparkContext: SparkContext, db: TPCHDatabase, queries: List[Int], repeat: Int) {
    for (queryID <- queries) {
      println("Query ${queryID}%02d")
      val query = Class.forName(f"main.scala.Q${queryID}%02d").newInstance.asInstanceOf[TPCHQuery]

      for (i <- List.range(0, repeat)) {
        val start = System.nanoTime()a
        val result = query.run(sparkContext, db)
        val end = System.nanoTime()
        result.show(result.count(), false)
        val elapsed_time_ms = (end - start) / scala.math.pow(10, 6)
        println("Time (ms): " + elapsed_time_ms)
      }
  }
}
