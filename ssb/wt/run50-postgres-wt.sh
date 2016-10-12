#!/usr/bin/env bash

source ../postgres/postgres-wt.cfg

queries=( 01 02 03 04 05 06 07 08 09 10 11 12 13 )
for query in ${queries[@]} ; do
  echo "Query wt$query.sql"
  rm tmp.sql &>/dev/null
  touch tmp.sql
  cat "wt$query.sql" >> tmp.sql
  # run each query 5 times.
  query=`cat tmp.sql`
  for i in `seq 1 5`; do
    $POSTGRES_EXEC -d $POSTGRES_DB_NAME <<EOF
\\timing on
$query
EOF
  done;
done;

rm tmp.sql &>/dev/null
