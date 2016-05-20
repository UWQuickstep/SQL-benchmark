#!/usr/bin/env bash

source config.sh

table_list=(
    lineorder
    part
    supplier
    customer
    ddate
)

echo "Creating SSB tables..."
$POSTGRES_EXEC -d $POSTGRES_DB_NAME -f ./create.sql
echo "Done"

for table_name in "${table_list[@]}"; do
    echo "Importing table ${table_name} ..."
    table_file_path="${SSB_TABLE_FILES_DIR}/${table_name}.tbl"
    $POSTGRES_EXEC -d $POSTGRES_DB_NAME <<EOF
    COPY ${table_name} FROM '${table_file_path}' WITH DELIMITER '|'
EOF
    echo "Done"
done
