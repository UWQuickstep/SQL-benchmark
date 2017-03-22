#!/bin/bash

temp_output_filename="temp-query-output-sizes-q01-modified.txt"
#rm -rf "${temp_output_filename}" &> /dev/null 
#for i in `seq 1 20`;
#do  
#  python generate-sql-query.py "$i" > temp.sql
#  ./htsize-perf.sh master-measure-output-size.cfg 2>&1 | tee -a "${temp_output_filename}" 
#  sleep 1s
#done

output_filename="query-output-sizes-q01-modified.txt"
rm -rf "${output_filename}" &> /dev/null 
touch "${output_filename}"

printf "HTSize,Output-size\n" > "${output_filename}"

grep "[0-9]\+\.[0-9]\+ MB\|[0-9]\+|" "${temp_output_filename}" -o | tr '\n', ',' | sed 's/|,/\n/g' | sed 's/ MB//g' | tee -a "${output_filename}"
