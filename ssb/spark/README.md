#### Requirements:
- Scala 2.10.x
- Spark 1.6.1
- sbt 1.0

#### Installation:
- Download  scala 2.10.5 from http://downloads.lightbend.com/scala/2.10.5/scala-2.10.5.tgz .
```
wget http://downloads.lightbend.com/scala/2.10.5/scala-2.10.5.tgz`
```
- Extract the archive
```
tar -zxvf scala-2.10.5
```
- Set the SCALA_HOME environment variable to point to the directory where you have extracted the archive
```
export SCALA_HOME=/fastdisk/scala-2.10.5

```
- Set the PATH environment variable to point to scala executable
```
export PATH=$SCALA_HOME/bin:$PATH

```
- Install sbt  from http://www.scala-sbt.org/0.13/docs/Setup.html
- Download Spark 1.6.1 http://spark.apache.org/downloads.html. 
- Set the SPARK_HOME environment variable.
```
If your spark download is in /home/spark-1.6.1/. The spark home can be set as :
  export SPARK_HOME=/home/spark-1.6.1
```
- Once that is done copy the files in the conf directory (**SQL-benchmark/ssb/spark/conf**) into your spark  configuration directory. The spark configuration directory can be found in **$SPARK_HOME/conf**.

#### Editing the configuration files:

##### spark-envs.sh
- **SPARK_LOCAL_DIRS** edit this  property to point to a directory  where you are sure to get a lot of disk space. This property controls the location that  spark uses for disk  writes.
- **SPARK_WORKER_INSTANCES**  This property controls the number of workers spawned when the command  **$SPARK_HOME/sbin/start-slave.sh** is run. The default value is 1.
- **SPARK_WORKER_CORES** This property controls the number of cores assigned to a worker. If ** SPARK_WORKER_INSTANCES** is set to 1 then, this parameter can be set to the total number of cores. If **SPARK_WORKER_INSTANCES** is set to greater than 1, this parameter should be  tuned to  limit the number of cores per worker. A correct number would be **NUM_CORES/SPARK_WORKER_INSTANCES**

### Starting Spark
- Start the spark master using
```
$SPARK_HOME/sbin/start-master.sh
```
This will start the master at port 7077.
The Web dashboard of the master should  be accessible  at port 8080 .
eg c220g2-011331.wisc.cloudlab.us:8080

- Access the  dashboard and  copy the url to the master. We will be using this to connect the slaves.
eg URL: spark://node-2.838.quickstep-pg0.wisc.cloudlab.us:7077

- use the master url obtained to start the slave as :
```
$SPARK_HOME/sbin/start-slave.sh <master-url>
```
This will spawn n workers, where n is the value of the **SPARK_WORKER_INSTANCES** in  spark-env.sh
#### Compiling the Script:
Assumming that you have already installed SCALA and sbt

- Navigate to the top most directory
```
cd SQL-benchmark/ssb/spark
```
- Type the command sbt assembly
```
sbt assembly
```
- If the compilation is successful, a jar , SSBQueries-assembly-1.0.jar , will be created in  target/scala-2.10/ .

#### Running the Script:

We will be running the scripts using the spark submit script:
```
$SPARK_HOME/bin/spark-submit
```
-If a single worker is used
```
$SPARK_HOME/bin/spark-submit \
  --class SSB \
  --master spark://node-2.838.quickstep-pg0.wisc.cloudlab.us:7077 \
  --driver-memory 20G \
  --executor-memory 130G \
  --total-executor-cores 80 \
  target/scala-2.10/SSBQueries-assembly-1.0.jar \
  --ssb_data  /newDisk1/ssb/data/sf1 \
  --cache true \
  --partitions  100
```
- --ssb_data - Path to the raw data files.
- --cache If set to true, the tables are cached in memory before the queries are run. 
- --partitions  Configures the number of partitions to use when shuffling data for joins or aggregations.
- --total-executor-cores  Controls the number of cores that spark-shell uses on the cluster.


-If more than one worker is used
```
$SPARK_HOME/bin/spark-submit \
  --class SSB \
  --master spark://node-2.838.quickstep-pg0.wisc.cloudlab.us:7077 \
  --driver-memory 20G \
  --executor-memory 33G \
  --executor-cores 20 \
  --num-executors 4\
  target/scala-2.10/SSBQueries-assembly-1.0.jar \
  --ssb_data  /newDisk1/ssb/data/sf1 \
  --cache true \
  --partitions  100
```
- --executor-memory The memory  per executor.
- --executor-cores  Share of cores for each executor. Generally  **TOTAL_CORES/SPARK_WORKER_INSTANCES**
- --num-executors  Number of worker instances.
**Note: The confgiguration parameters have to be tuned to the size of the data set**

#### References:
- http://spark.apache.org/docs/latest/spark-standalone.html
- http://spark.apache.org/docs/latest/sql-programming-guide.html
- http://spark.apache.org/docs/latest/submitting-applications.html
