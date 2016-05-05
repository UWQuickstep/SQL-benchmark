source monetdb.cfg

queries=( 01 02 03 04 05 06 07 08 09 10 11 12 13 )
for query in ${queries[@]} ; do
  echo "Query $query.sql"
  rm tmp.sql &>/dev/null
  touch tmp.sql
  # run each query 5 times.
  for i in `seq 1 5`;
  do
    cat $query.sql >> tmp.sql 
  done    
  if ! mclient -d ssb10  --interactive=ms < tmp.sql | grep tuple;
  then
    echo "MonetDB failed on query $query, exiting."
    exit 1
  fi
done
