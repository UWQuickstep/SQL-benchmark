source monetdb.cfg

queries=( 01 02 03 04 05 06 07 08 09 10 11 12 13 )
rm temp_batch.sql &>/dev/null
touch temp_batch.sql 
for query in ${queries[@]} ; do
  cat "${query}.sql" >> temp_batch.sql
done

for i in `seq 1 5`; do
  if ! time `mclient -d ssb100 < temp_batch.sql &>/dev/null`;
  then
       echo "MonetDB failed on query $query, exiting."
       exit 1
  fi
done

