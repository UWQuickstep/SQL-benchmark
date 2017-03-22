#!/bin/bash

temp_output_filename_prefix="data/temp-wo-perf-q01-modified"
for i in `seq 1 20`;
do  
  temp_output_filename=${temp_output_filename_prefix}"-${i}predicates.txt"
  echo "${temp_output_filename}"
  rm -rf "${temp_output_filename}" &> /dev/null 
  python generate-sql-query.py "$i" > temp.sql
  ./htsize-perf.sh measure-probe-wo-time.cfg 2>&1 | tee -a "${temp_output_filename}"
  sleep 1s
done
