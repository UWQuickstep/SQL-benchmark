package main.scala

import org.apache.spark.SparkContext
import org.apache.spark.sql._

abstract class TPCHQuery {
  def getName(): String
  def run(sparkContext: SparkContext, database: TPCHDatabase): Dataset
}

object TPCHQuery {
  def main(args: Array[String]) {

    path = "SOME_PATH"
    times = 5
    numberOfQueries = 22
    queries = List.range(1, numberOfQueries + 1)
    val config = new SparkConf().setAppName("TPCH Benchmark")
    val sparkContext = new SparkContext(config)

    val database = new TPCHDatabase(sparkContext, path)

    runQueries(sparkContext, database, numberOfQueries, times)
  }

  def runQueries(sparkContext: SparkContext, db: TPCHDatabase, queries: List[Int], repeat: Int) {
    for (queryID <- queries) {
      println("Query ${queryID}%02d")
      val query = Class.forName(f"main.scala.Q${queryID}%02d").newInstance.asInstanceOf[TPCHQuery]

      val start = System.nanoTime()

      val result = query.run(sparkContext, db)
      val end = System.nanoTime()
      val elapsed_time_ms = (end - start) / scala.math.pow(10, 6)
      println("Time (ms): " + elapsed_time_ms)
    }
  }
}
