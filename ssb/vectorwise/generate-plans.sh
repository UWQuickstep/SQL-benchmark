queries=( 01 02 03 04 05 06 07 08 09 10 11 12 13 )
for query in ${queries[@]} ; do
  echo "Query $query.sql"
  rm ssb-plan-$query.txt &> /dev/null
  sed -i 's/\\g/ with qep\\p\\g/g' $query.sql
  sql -s ssb100 < $query.sql | tee ssb-plan-$query.txt
  sed -i 's/with qep\\p//g' $query.sql
done
