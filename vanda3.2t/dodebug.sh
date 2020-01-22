#!/bin/bash

for i in {1..8}
do
    mysql -h 127.0.0.1 -P 4000 -u root -D vandat -N -e "select id, log(id), ACOS(k),ACOS(id),MOD(k,id) from sbtest${i};" &
done
