QS_ARGS_STORAGE="-storage_path="$QS_STORAGE


function run_queries {
  # Runs each SSB query several times.
  QSEXE="$QS $QS_ARGS_BASE $QS_ARGS_NUMA_RUN $QS_ARGS_STORAGE"
  queries=( 01 02 03 04 05 06 07 08 09 10 11 12 13 )
  for query in ${queries[@]} ; do
    echo "Query wt$query.sql"
    rm tmp.sql &>/dev/null
    touch tmp.sql
    # run each query 3 times.
    for i in `seq 1 5`;
    do
      cat "wt$query.sql" >> tmp.sql
    done
    if ! $QSEXE < tmp.sql ;
    then
      echo "Quickstep failed on query $query, exiting."
      exit 1
    fi
  done
  rm tmp.sql &>/dev/null
}

function analyze_tables {
  # Runs the analyze command on quickstep. 
  QSEXE="$QS $QS_ARGS_BASE $QS_ARGS_NUMA_RUN $QS_ARGS_STORAGE"
  rm tmp.sql &>/dev/null
  touch tmp.sql
  echo "\analyze" >> tmp.sql
  if ! $QSEXE < tmp.sql ;
  then
    echo "Quickstep failed on analyze, exiting."
    exit 1
  fi
  rm tmp.sql &> /dev/null
}

if [ ! -x $QS ] ; then
  echo "Given Quickstep executable not found: $QS"
  echo "Specify it in quickstep.cfg."
  exit
fi

# Load and analyze data.
#if [ $LOAD_DATA = "true" ] ; then
  #load_data
  #analyze_tables
#fi
#analyze_tables
run_queries

