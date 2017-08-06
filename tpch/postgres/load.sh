#!/usr/bin/env bash

source config.sh

table_list=(
    part
    supplier
    partsupp
    customer
    orders
    lineitem
    nation
    region
)

echo "Creating TPC-H tables..."
$POSTGRES_EXEC -d $POSTGRES_DB_NAME -f ./create.sql
echo "Creating database is done."

for table_name in "${table_list[@]}"; do
    echo "Importing table ${table_name} ..."
    table_file_path="${TPCH_TABLE_FILES_DIR}/${table_name}.tbl"
    $POSTGRES_EXEC -d $POSTGRES_DB_NAME <<EOF
    \\timing on
    COPY ${table_name} FROM '${table_file_path}' WITH DELIMITER '|'
EOF
done
echo "Importing is done."

echo "Adding foreign key constraints..."
$POSTGRES_EXEC -d $POSTGRES_DB_NAME <<EOF
\\timing on
ALTER TABLE supplier
ADD FOREIGN KEY(s_nationkey) REFERENCES nation(n_nationkey);

ALTER TABLE partsupp
ADD FOREIGN KEY(ps_partkey) REFERENCES part(p_partkey);

ALTER TABLE partsupp
ADD FOREIGN KEY(ps_suppkey) REFERENCES supplier(s_suppkey);

ALTER TABLE customer
ADD FOREIGN KEY(c_nationkey) REFERENCES nation(n_nationkey);

ALTER TABLE orders
ADD FOREIGN KEY(o_custkey) REFERENCES customer(c_custkey);

ALTER TABLE lineitem
ADD FOREIGN KEY(l_orderkey) REFERENCES orders(o_orderkey);

ALTER TABLE lineitem
ADD FOREIGN KEY(l_partkey) REFERENCES part(p_partkey);

ALTER TABLE lineitem
ADD FOREIGN KEY(l_suppkey) REFERENCES supplier(s_suppkey);

ALTER TABLE nation
ADD FOREIGN KEY(n_regionkey) REFERENCES region(r_regionkey);

EOF
echo "Adding foreign key constraints is done."

echo "Analyzing the database..."
$POSTGRES_EXEC -d $POSTGRES_DB_NAME <<EOF
ANALYZE
EOF
echo "Analyzing is done."
