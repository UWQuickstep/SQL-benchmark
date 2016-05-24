#### Requirements:
- Scala 2.10.x
- Spark 1.6.1
- sbt 1.0

#### Installation:
- Download and install scala 2.10.5 from http://www.scala-lang.org/download/2.10.5.html. Any 2.10 version should suffice.
- Install sbt  from http://www.scala-sbt.org/0.13/docs/Setup.html
- Download Spark 1.6.1 http://spark.apache.org/downloads.html. (you do not have to build spark)
-set the SPARK_HOME environment variable.
```
If your spark download is in /home/spark-1.6.1/. The spark home can be set as :
  export SPARK_HOME=/home/spark-1.6.1
```
- Once that is done copy the files in the conf directory into your spark  configuration directory. The spark configuration directory can be found in **$SPARK_HOME/conf**.
```
cp -r  conf  $SPARK_HOME/conf
```
#### Editing the configuration files:
```
cd $SPARK_HOME/conf
```
- Edit the  SPARK_LOCAL_DIRS property  to  a directory of  your choice where you are sure to get a lot of disk space. This property can be found in the **spark-envs.sh** file.
- eg: if your spark  download is at  /u/r/l/rl/Downloads/spark-1.6.1
this will be your **SPARK_HOME**, then the  configuration  directory would be
$SPARK_HOME/conf.

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
This will spawn  a single worker .

#### Compiling the Script:
Assumming that you have already installed SCALA and sbt

- Navigate to the top most directory
- Type the command sbt assembly
- If the compilation is successful, a jar , SSBQueries-assembly-1.0.jar , will be created in  target/scala-2.10/ .

#### Running the Script:

We will be running the scripts using the spark submit script:
```
$SPARK_HOME/bin/spark-submit
```
eg:
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
- --ssb_data - indicates the path to the raw data files
- --cache caches the tables before the queries are run
- --partitions  number of reducers
- --total-executor-cores  number of executor threads that can run at a time. Controls the number of tasks that can happen in parallel

**Note: THe driver memory as well the the executor memory have to be tuned according to the size of the data set **