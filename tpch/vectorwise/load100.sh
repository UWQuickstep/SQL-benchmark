source vectorwise.cfg

# Loads tpch tables into a vectorwise database where the tables have already been created.
COUNTER=0
for tblfile in $TPCH_DATA_PATH/*.tbl* ; do
  echo "Loading from $tblfile"
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

  cmd="vwload --cluster --textmode --rollback off --table $TBL --log $PWD tpch100 --timing $tblfile"
  echo $cmd
  eval $cmd

  let COUNTER=COUNTER+1 
done
echo "Done loading. Loaded $COUNTER files."

echo "Generating stats for the tables..."
optimizedb tpch100
echo "Done generating stats for the tables"
