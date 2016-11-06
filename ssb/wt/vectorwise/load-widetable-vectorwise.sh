source vectorwise.cfg

# Loads widetable into a vectorwise database where the table has already been created.
COUNTER=0
for tblfile in $WIDETABLE_RAW_DATA/*.tbl* ; do
  echo "Loading from $tblfile"
  # Resolve which table the file should be loaded into.
  TBL=""
  if [[ $tblfile == *"widetable"* ]]
  then
    TBL="widetable"
  fi

  cmd="vwload --cluster --textmode --rollback off --table $TBL --log $PWD ssbwidetable --timing $tblfile"
  echo $cmd
  eval $cmd

  let COUNTER=COUNTER+1 
done
echo "Done loading. Loaded $COUNTER files."

echo "Generating stats for the tables..."
optimizedb ssbwidetable
echo "Done generating stats for the tables"
