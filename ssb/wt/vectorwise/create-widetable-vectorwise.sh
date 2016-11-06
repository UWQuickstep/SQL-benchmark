#sudo service actian-vectorVW restart
 
source vectorwise.cfg

destroydb ssbwidetable

# Create directories
mkdir -p $VECTORWISE_DATA_PATH &> /dev/null
mkdir -p $VECTORWISE_DATA_PATH/data &> /dev/null
mkdir -p $VECTORWISE_DATA_PATH/checkpoint &> /dev/null
mkdir -p $VECTORWISE_DATA_PATH/journal &> /dev/null
mkdir -p $VECTORWISE_DATA_PATH/dump &> /dev/null
mkdir -p $VECTORWISE_DATA_PATH/work &> /dev/null

rm -rf creationtemp.sql &> /dev/null
touch creationtemp.sql 

# The \g is required for vectorwise to execute the query.
datastr="CREATE LOCATION ssbwidetabledata WITH AREA = '$VECTORWISE_DATA_PATH/data', USAGE = (DATABASE)\g;"
echo $datastr >> creationtemp.sql 

checkpointstr="CREATE LOCATION ssbwidetablecheckpoint WITH AREA = '$VECTORWISE_DATA_PATH/checkpoint', USAGE = (CHECKPOINT)\g;"
echo $checkpointstr >> creationtemp.sql 

journalstr="CREATE LOCATION ssbwidetablejournal WITH AREA = '$VECTORWISE_DATA_PATH/journal', USAGE = (JOURNAL)\g;"
echo $journalstr >> creationtemp.sql 

dumpstr="CREATE LOCATION ssbwidetabledump WITH AREA = '$VECTORWISE_DATA_PATH/dump', USAGE = (DUMP)\g;"
echo $dumpstr >> creationtemp.sql 

workstr="CREATE LOCATION ssbwidetablework WITH AREA = '$VECTORWISE_DATA_PATH/work', USAGE = (WORK)\g;"
echo $workstr >> creationtemp.sql 

cat creationtemp.sql 

# Create data location with vectorwise. 
sql iidbdb < creationtemp.sql

cmd="createdb -dssbwidetabledata -cssbwidetablecheckpoint -jssbwidetablejournal -bssbwidetabledump -wssbwidetablework ssbwidetable"
echo $cmd
eval $cmd

sql ssbwidetable < create-widetable-vectorwise.sql

# Show the created tables. 
statdump ssbwidetable
