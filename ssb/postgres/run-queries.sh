#!/usr/bin/env bash

source config.sh

for i in `seq -f "%02g" 1 13`; do
    query_file="${i}.sql"
    query=`cat "${query_file}"`
    explain_query="EXPLAIN ANALYZE ${query}" 
    $POSTGRES_EXEC -d $POSTGRES_DB_NAME <<EOF
	$explain_query
EOF
done; 

