# Load user-defined environment variables

echo "Loading settings from $1"
if ! source $1 ; then echo "Failed to load config" ; exit 1 ; fi

# Print some debug information about this test.
cat $1

QS_ARGS_STORAGE="-storage_path="$QS_STORAGE

function load_data {
  # Creates a fresh load of the ssb data.
  if [ -d $TPCH_DATA_PATH ] ; then
    rm -rf $QS_STORAGE
    QSEXE="$QS $QS_ARGS_BASE $QS_ARGS_STORAGE $QS_ARGS_NUMA_LOAD"
    
    # Use quickstep to generate the catalog file in a new folder.
    $QSEXE -initialize_db=true < $CREATE_SQL

    COUNTER=0
    for tblfile in $TPCH_DATA_PATH/*.tbl* ; do
      # Resolve which table the file should be loaded into.
      TBL=""
      if [[ $tblfile == *"region"* ]]
      then
        TBL="region"
      elif [[ $tblfile == *"nation"* ]]
      then
        TBL="nation"
      elif [[ $tblfile == *"supplier"* ]]
      then
        TBL="supplier"
      elif [[ $tblfile == *"customer"* ]]
      then
        TBL="customer"
      elif [[ $tblfile == *"part."* ]]
      then
        TBL="part"
      elif [[ $tblfile == *"partsupp"* ]]
      then
        TBL="partsupp"
      elif [[ $tblfile == *"orders"* ]]
      then
        TBL="orders"
      elif [[ $tblfile == *"lineitem"* ]]
      then
        TBL="lineitem"
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
  queries=( 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 )
  for query in ${queries[@]} ; do
    echo "Query $query.sql"
    rm tmp.sql &>/dev/null
    touch tmp.sql
    # run each query 3 times.
    for i in `seq 1 5`;
    do
      cat $query.sql >> tmp.sql 
    done
    # Run quickstep with with a timeout of 15 minutes. This is because no set of
    # queries should run over 15 minutes.    
    timeout 15m $QSEXE < tmp.sql
    if [ $? = 124 ] ;
    then
      echo "Quickstep timed out on query $query, continueing to next query."
    elif [ $? != 0  ] ;
    then
      echo "Quickstep failed on query $query, continueing to next query."
    fi
  done
  rm tmp.sql &>/dev/null
}

if [ ! -x $QS ] ; then
  echo "Given Quickstep executable not found: $QS"
  echo "Specify it in quickstep.cfg."
  exit
fi

# Load data.
if [ $LOAD_DATA = "true" ] ; then
  load_data
fi

run_queries