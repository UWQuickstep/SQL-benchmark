#!/usr/bin/env bash

source config.sh

table_list=(
    part
    supplier
    customer
    ddate
    lineorder
)

echo "Creating SSB tables..."
$POSTGRES_EXEC -d $POSTGRES_DB_NAME -f ./create.sql
echo "Creating database is done."

for table_name in "${table_list[@]}"; do
    echo "Importing table ${table_name} ..."
    table_file_path="${SSB_TABLE_FILES_DIR}/${table_name}.tbl"
    $POSTGRES_EXEC -d $POSTGRES_DB_NAME <<EOF
    \\timing on
    COPY ${table_name} FROM '${table_file_path}' WITH DELIMITER '|'
EOF
done
echo "Importing is done."

echo "Adding foreign key constraints..."
$POSTGRES_EXEC -d $POSTGRES_DB_NAME <<EOF
\\timing on
ALTER TABLE lineorder
ADD FOREIGN KEY(lo_custkey) REFERENCES customer(c_custkey);

ALTER TABLE lineorder
ADD FOREIGN KEY(lo_partkey) REFERENCES part(p_partkey);

ALTER TABLE lineorder
ADD FOREIGN KEY(lo_suppkey) REFERENCES supplier(s_suppkey);

ALTER TABLE lineorder
ADD FOREIGN KEY(lo_orderdate) REFERENCES ddate(d_datekey);

ALTER TABLE lineorder
ADD FOREIGN KEY(lo_commitdate) REFERENCES ddate(d_datekey);
EOF
echo "Adding foreign key constraints is done."

echo "Analyzing the database..."
$POSTGRES_EXEC -d $POSTGRES_DB_NAME <<EOF
ANALYZE
EOF
echo "Analyzing is done."
