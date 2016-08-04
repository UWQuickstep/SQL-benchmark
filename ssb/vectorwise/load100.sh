source vectorwise.cfg

# Loads ssb tables into a vectorwise database where the tables have already been created.
COUNTER=0
for tblfile in $SSB_DATA_PATH/*.tbl* ; do
  echo "Loading from $tblfile"
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

  echo "Loading $TBL ..."
  cmd="vwload --cluster --textmode --rollback off --table $TBL --log $PWD ssb100 --timing $tblfile"
  echo $cmd
  eval $cmd

  let COUNTER=COUNTER+1 
done
echo "Done loading. Loaded $COUNTER files."

echo "Generating stats for the tables..."
optimizedb ssb100
echo "Done generating stats for the tables"
