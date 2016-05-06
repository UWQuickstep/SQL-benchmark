CREATE_SQL="create-widetable.sql"

# Path to Quickstep cli shell.
QS=/home/spehlmann/qs/build/quickstep_cli_shell

# Loads all the database data again. (False if already built)
LOAD_FRESH="true"

# Where Quickstep will write Storage Blocks to.
QS_STORAGE=store100

QS_ARGS_BASE="-printing_enabled=false -aggregate_hashtable_type=SeparateChaining"

# Leave empty if no NUMA.
QS_ARGS_NUMA_LOAD="-num_workers=10 -worker_affinities=0,4,8,12,16,20,24,28,32,36"
QS_ARGS_NUMA_RUN="-num_workers=40 -worker_affinities=0,4,8,12,16,20,24,28,32,36,1,5,9,13,17,21,25,29,33,37,2,6,10,14,18,22,26,30,34,38,3,7,11,15,19,23,27,31,35,39"

#QS_ARGS_NUMA_RUN="-num_workers=80 -worker_affinities=0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64,68,72,76,1,5,9,13,17,21,25,29,33,37,41,45,49,53,57,61,65,69,73,77,2,6,10,14,18,22,26,30,34,38,42,46,50,54,58,62,66,70,74,78,3,7,11,15,19,23,27,31,35,39,43,47,51,55,59,63,67,71,75,79"



### End config.

QSEXE_LOAD="$QS -storage_path=$QS_STORAGE $QS_ARGS_BASE $QS_ARGS_NUMA_LOAD"
QSEXE_RUN="$QS -storage_path=$QS_STORAGE $QS_ARGS_BASE $QS_ARGS_NUMA_RUN"

if [ $LOAD_FRESH = "true" ] ; then
  rm $QS_STORAGE -rf &>/dev/null
  $QSEXE_LOAD -initialize_db=true < $CREATE_SQL
  $QSEXE_LOAD < load-widetable-sf100.sql
fi

queries=( 01 02 03 04 05 06 07 08 09 10 11 12 13 )
for query in ${queries[@]} ; do
  echo "Query $query.sql"
  rm tmp.sql &>/dev/null
  touch tmp.sql
  # run each query 3 times.
  for i in `seq 1 5`;
  do
    cat w$query.sql >> tmp.sql 
  done    
  if ! $QSEXE_RUN < tmp.sql ;
  then
    echo "Quickstep failed on query $query, exiting."
    exit 1
  fi
done

rm tmp.sql &>/dev/null
