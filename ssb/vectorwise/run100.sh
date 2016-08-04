source vectorwise.cfg 

queries=( 01 02 03 04 05 06 07 08 09 10 11 12 13 )
rm result.txt &> /dev/null
rm query-times.txt &> /dev/null
touch result.txt
for query in ${queries[@]} ; do
  echo "Query $query.sql"
  rm tmp.sql &>/dev/null
  touch tmp.sql
  cat $query.sql >> tmp.sql
  # run each query 5 times.
  for i in `seq 1 5`;
  do
    sql -s ssb100 < tmp.sql 2>&1 | tee -a result.txt;
  done
done

rm tmp.sql &>/dev/null
grep row.*secs result.txt | grep -o '[0-9]\+\.[0-9]\+' | tee query-times.txt
python process.py query-times.txt 
