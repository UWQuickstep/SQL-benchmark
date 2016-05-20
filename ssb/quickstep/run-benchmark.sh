# Load user-defined environment variables

echo "Loading settings from $1"
if ! source $1 ; then echo "Failed to load config" ; exit 1 ; fi

# Print some debug information about this test.
cat $1

QS_ARGS_STORAGE="-storage_path="$QS_STORAGE

function load_data {
  # Creates a fresh load of the ssb data.
  if [ -d $SSB_DATA_PATH ] ; then
    rm -rf $QS_STORAGE
    QSEXE="$QS $QS_ARGS_BASE $QS_ARGS_STORAGE $QS_ARGS_NUMA_LOAD"
    
    # Use quickstep to generate the catalog file in a new folder.
    $QSEXE -initialize_db=true < $CREATE_SQL

    COUNTER=0
    for tblfile in $SSB_DATA_PATH/*.tbl* ; do
      # Resolve which table the file should be loaded into.
      TBL=""
      if [[ $tblfile == *"date"* ]]
      then
        TBL="ddate"
      elif [[ $tblfile == *"supplier"* ]]
      then
        TBL="supplier"
      elif [[ $tblfile == *"lineorder"* ]]
      then
        TBL="lineorder"
      elif [[ $tblfile == *"customer"* ]]
      then
        TBL="customer"
      elif [[ $tblfile == *"part"* ]]
      then
        TBL="part"
      fi

      if ! $QSEXE <<< "COPY $TBL FROM '$tblfile' WITH (DELIMITER '|');" ;
      then
        echo "Quickstep load failed."; 
        exit 1;
      fi

      let COUNTER=COUNTER+1 
    done
    echo "Done loading. Loaded $COUNTER files."
  else
    echo "SSB data folder $SSB_DATA_PATH not found, quitting"
    exit
  fi
}

function run_queries {
  # Runs each SSB query several times.
  QSEXE="$QS $QS_ARGS_BASE $QS_ARGS_NUMA_RUN $QS_ARGS_STORAGE"
  queries=( 01 02 03 04 05 06 07 08 09 10 11 12 13 )
  for query in ${queries[@]} ; do
    echo "Query $query.sql"
    rm tmp.sql &>/dev/null
    touch tmp.sql
    # run each query 3 times.
    for i in `seq 1 5`;
    do
      cat $query.sql >> tmp.sql 
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
if [ $LOAD_DATA = "true" ] ; then
  load_data
  analyze_tables
fi

run_queries
