#!/bin/bash

function chget_csv() {
    echo "q1_1,q1_2,q1_3,q2_1,q2_2,q2_3,q3_1,q3_2,q3_3,q3_4,q4_1,q4_2,q4_3" > csv/query.csv
    for f in `ls *.out`;
    do
        rtime=`cat ${f} | grep real | awk '{print $2}'`
        input="${input},${rtime}"
    done
    echo "${input}" >> csv/query.csv
}
