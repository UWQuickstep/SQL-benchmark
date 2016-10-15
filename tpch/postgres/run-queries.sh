#!/usr/bin/env bash

source config.sh

for i in `seq -f "%02g" 1 22`; do
    echo "QUERY ${i}"
    for j in `seq 1 5`; do
        echo "Run ${j}"
        query_file="${i}.sql"
        query=`cat "${query_file}"`
        explain_query="EXPLAIN ANALYZE ${query}"
        $POSTGRES_EXEC -d $POSTGRES_DB_NAME <<EOF
\\timing on
$query 
EOF
    done;
done;

