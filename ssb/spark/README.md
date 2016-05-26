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
```
wget http://apache.claz.org/spark/spark-1.6.1/spark-1.6.1.tgz 
```
- Extract the archive
```
tar -zxvf spark-1.6.1.tgz 
```
- Set the SPARK_HOME environment variable.
```
If your spark download is in /home/spark-1.6.1/. The spark home can be set as :
  export SPARK_HOME=/fastdisk/spark-1.6.1
  
```
- Once that is done copy the files in the conf directory (**SQL-benchmark/ssb/spark/conf**) into your spark  configuration directory. The spark configuration directory can be found in **$SPARK_HOME/conf**.

```
  cp SQL-benchmark/ssb/spark/conf/* $SPARK_HOME/conf/.
```
#### Editing the configuration files:

##### spark-env.sh
- **SPARK_LOCAL_DIRS** Edit this  property to point to a directory where you are sure to get a lot of disk space. This property controls the location that  spark uses for disk  writes.
- **SPARK_WORKER_INSTANCES**  This property controls the number of workers spawned when the command  **$SPARK_HOME/sbin/start-slave.sh** is run. The default value is 1.
- **SPARK_WORKER_CORES** This property controls the number of cores assigned to a worker. If ** SPARK_WORKER_INSTANCES** is set to 1 then, this parameter can be set to the total number of cores. If **SPARK_WORKER_INSTANCES** is set to greater than 1, this parameter should be  tuned to  limit the number of cores per worker. A correct number would be **NUM_CORES/SPARK_WORKER_INSTANCES**

###### Note:

for SSB SCALE FACTOR 50

```
SPARK_WORKER_INSTANCES=4
SPARK_WORKER_CORES=10
```
##### spark-defaults.conf
- **spark.local.dir** Set this property to take the same value as that of **SPARK_LOCAL_DIRS**

### Building Spark
```
cd $SPARK_HOME
```
```
build/mvn  -DskipTests clean package 
```
- The build should proceed fine. If you encounter a failure of build that says **ERROR] No goals have been specified for this build. You must specify a valid lifecycle phase or a goal in the format <plugin-prefix>:<goal> or <plugin-group-id>:<plugin-artifact-id>[:<plugin-version>]:<goal>**, do the following:

```
 build/zinc-0.3.5.3/bin/zinc -shutdown
```
and repeat the build command.
### Starting Spark
- Start the spark master using
```
$SPARK_HOME/sbin/start-master.sh
```
This will start the master at port 7077.
The Web dashboard of the master should  be accessible  at port 8080 .
eg c220g2-011331.wisc.cloudlab.us:8080

- Access the  dashboard and  copy the url to the master. We will be using this to connect the slaves.
eg URL: spark://node-2.838.quickstep-pg0.wisc.cloudlab.us:7077 . The master url can also be obtained from the log file of the master.
```
node-2:/fastdisk/spark-1.6.1$ $SPARK_HOME/sbin/start-master.sh
starting org.apache.spark.deploy.master.Master, logging to /fastdisk/spark-1.6.1/logs/spark-rogers-org.apache.spark.deploy.master.Master-1-node-2.wtnobw.quickstep-pg0.wisc.cloudlab.us.out
cat /fastdisk/spark-1.6.1/logs/spark-rogers-org.apache.spark.deploy.master.Master-1-node-2.wtnobw.quickstep-pg0.wisc.cloudlab.us.out
Spark Command: /usr/lib/jvm/java-7-openjdk-amd64//bin/java -cp /fastdisk/spark-1.6.1/conf/:/fastdisk/spark-1.6.1/assembly/target/scala-2.10/spark-assembly-1.6.1-hadoop2.2.0.jar:/fastdisk/spark-1.6.1/lib_managed/jars/datanucleus-api-jdo-3.2.6.jar:/fastdisk/spark-1.6.1/lib_managed/jars/datanucleus-core-3.2.10.jar:/fastdisk/spark-1.6.1/lib_managed/jars/datanucleus-rdbms-3.2.9.jar -Xms1g -Xmx1g -XX:MaxPermSize=256m org.apache.spark.deploy.master.Master --ip node-2.wtnobw.quickstep-pg0.wisc.cloudlab.us --port 7077 --webui-port 8080
```
From the contents of the file, *org.apache.spark.deploy.master.Master --ip node-2.wtnobw.quickstep-pg0.wisc.cloudlab.us --port 7077 * gives us the master url and the port, i.e. ** spark://node-2.wtnobw.quickstep-pg0.wisc.cloudlab.us:7077 **.
- The Web UI of the master can be accessred through ** http://node-2.wtnobw.quickstep-pg0.wisc.cloudlab.us:8080 **

- Use the master url obtained to start the slave as :
```
$SPARK_HOME/sbin/start-slave.sh <master-url>

```

```
e.g $SPARK_HOME/sbin/start-slave.sh spark://node-2.wtnobw.quickstep-pg0.wisc.cloudlab.us:7077
```
This will spawn n workers, where n is the value of the **SPARK_WORKER_INSTANCES** in  spark-env.sh
#### Compiling the Script:
Assumming that you have already installed SCALA and sbt

- Navigate to the spark script directory
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
-If a single worker is used, e.g.
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
  --executor-cores 10 \
  --num-executors 4\
  target/scala-2.10/SSBQueries-assembly-1.0.jar \
  --ssb_data  /slowdisk/data/sf50/
  --cache true \
  --partitions  100
```
- --executor-memory The memory  per executor.
- --executor-cores  Share of cores for each executor. Generally  **TOTAL_CORES/SPARK_WORKER_INSTANCES**
- --num-executors  Number of worker instances.

**Note: The configuration parameters have to be tuned to the size of the data set**
- **For the 50 scale factor we would use something like**
```
$SPARK_HOME/bin/spark-submit \
  --class SSB \
  --master spark://node-2.wtnobw.quickstep-pg0.wisc.cloudlab.us:7077 \
  --driver-memory 20G \
  --executor-memory 33G \
  --executor-cores 10 \
  --num-executors 4\
  target/scala-2.10/SSBQueries-assembly-1.0.jar \
  --ssb_data  /slowdisk/data/sf50/ \
  --cache true \
  --partitions  100
```
#### Results:
Once all the queries are done, two csv files are generated
- load_times.csv This gives the loading times for each of the tables.
- sf50_Queries+all_result.csv - This file is generated for the SSB50 scale factor. This has the runtimes of all the 13 queries for 5 iterations. The result is a 5 x 13 matrix where each row has a run time of all 13 queries for that iteration.
- The runtimes can be obtained by post-processing the above csv file as  follows:

```
python process_result.py sf50_Queries+all_result.csv
```
This gives the run times for each of the 13 queries.



#### References:
- http://spark.apache.org/docs/latest/spark-standalone.html
- http://spark.apache.org/docs/latest/sql-programming-guide.html
- http://spark.apache.org/docs/latest/submitting-applications.html
