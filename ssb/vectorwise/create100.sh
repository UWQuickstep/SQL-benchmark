sudo service actian-vectorVW restart
 
source vectorwise.cfg

destroydb ssb100

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
datastr="CREATE LOCATION ssbdata WITH AREA = '$VECTORWISE_DATA_PATH/data', USAGE = (DATABASE)\g;"
echo $datastr >> creationtemp.sql 

checkpointstr="CREATE LOCATION ssbcheckpoint WITH AREA = '$VECTORWISE_DATA_PATH/checkpoint', USAGE = (CHECKPOINT)\g;"
echo $checkpointstr >> creationtemp.sql 

journalstr="CREATE LOCATION ssbjournal WITH AREA = '$VECTORWISE_DATA_PATH/journal', USAGE = (JOURNAL)\g;"
echo $journalstr >> creationtemp.sql 

dumpstr="CREATE LOCATION ssbdump WITH AREA = '$VECTORWISE_DATA_PATH/dump', USAGE = (DUMP)\g;"
echo $dumpstr >> creationtemp.sql 

workstr="CREATE LOCATION ssbwork WITH AREA = '$VECTORWISE_DATA_PATH/work', USAGE = (WORK)\g;"
echo $workstr >> creationtemp.sql 

cat creationtemp.sql 

# Create data location with vectorwise. 
sql iidbdb < creationtemp.sql

cmd="createdb -dssbdata -cssbcheckpoint -jssbjournal -bssbdump -wssbwork ssb100"
echo $cmd
eval $cmd

sql ssb100 < create.sql

# Show the created tables. 
statdump ssb100
