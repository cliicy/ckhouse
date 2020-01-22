#!/bin/bash

cfg_file=$1
if [ "$1" = "" ]; then echo -e "Usage:\n\t2_initdb.sh cfg_file"; exit 1; fi
if [ ! -e ${cfg_file} ]; then echo "can't find configuration file [${cfg_file}]", exit 2; fi
source ${cfg_file}

##start clickhouse-server
sudo /etc/init.d/clickhouse-server start

for i in {1..1200};
do
    sudo cat ${ch_log} | grep "Ready for connections"
    if [ $? -eq 0 ]; then echo started; sleep 10; break; fi
    echo "waiting for clickhouse to start"
    sleep 3
done

#CREATE DATABASE vandat;
