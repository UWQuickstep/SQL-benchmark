queries=( 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 )
for query in ${queries[@]} ; do
  echo "Query $query.sql"
  rm tpch-plan-$query.txt &> /dev/null
  sed -i 's/\\g/ with qep\\p\\g/g' $query.sql
  sql -s tpch100 < $query.sql | tee tpch-plan-$query.txt
  sed -i 's/with qep\\p//g' $query.sql
done

tar -zcvf vectorwise-tpch-plans.tar.gz tpch-plan-*.txt
rm tpch-plan*.txt 
