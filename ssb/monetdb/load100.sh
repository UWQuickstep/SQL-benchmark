source monetdb.cfg

# Loads ssb tables into a Monet database where the tables have already been created.
COUNTER=0
for tblfile in $SSB100_PATH/*.tbl* ; do
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
  
  echo "Loading $TBL..."
  if ! mclient -p 54322 -d ssb100 --interactive=ms <<< "COPY INTO $TBL FROM '$tblfile' DELIMITERS '|','\n';";
  then
    echo "MonetDB load failed."; 
    exit 1;
  fi

  let COUNTER=COUNTER+1 
done
echo "Done loading. Loaded $COUNTER files."
