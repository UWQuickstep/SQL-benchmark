source monetdb.cfg

# Loads ssb tables into a Monet database where the tables have already been created.
COUNTER=0
for tblfile in $TPCH100_PATH/*.tbl* ; do
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

  if ! mclient -d tpch100 --interactive <<< "COPY INTO $TBL FROM '$tblfile' DELIMITERS '|','\n';";
  then
    echo "MonetDB load failed on $tblfile in table $TBL, continuing"; 
  fi

  let COUNTER=COUNTER+1 
done
echo "Done loading. Loaded $COUNTER files."
