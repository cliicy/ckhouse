#!/bin/bash

sudo /etc/init.d/clickhouse-server stop

serverlist="clickhouse-server.pid"
for service in ${serverlist}
do
    sudo kill -9 `ps aux | grep -v grep | grep -e ${service} | cut -c 10-15`
done

