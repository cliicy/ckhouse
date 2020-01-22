#!/bin/bash

#output_dir=$1
#sql_path=/opt/app/benchmark/clickhouse/tables_dbgen/query

query_list="q1_1.sql q1_2.sql q1_3.sql q2_1.sql q2_2.sql q2_3.sql q3_1.sql q3_2.sql q3_3.sql q3_4.sql q4_1.sql q4_2.sql q4_3.sql"
#query_list="q1_1.sql"
for q in ${query_list};
do
    sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
    (clickhouse-client -t < ${sql_path}/${q}) > ${output_dir}/${q%.sql}.out 2>&1
done
