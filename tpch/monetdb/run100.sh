source monetdb.cfg

queries=( 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 )
for query in ${queries[@]} ; do
  echo "Query $query.sql"
  rm tmp.sql &>/dev/null
  touch tmp.sql
  cat $query.sql >> tmp.sql
  # run each query 5 times.
  for i in `seq 1 5`;
  do
    if ! mclient -d tpch100 -t clock --interactive < tmp.sql | grep "tuple\|clk:";
    then
       echo "MonetDB failed on query $query, skipping to next query."
       break
     fi
  done    
  
done

rm tmp.sql &>/dev/null
