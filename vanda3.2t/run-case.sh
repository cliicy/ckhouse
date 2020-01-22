#!/bin/bash

#sed -i s/table_size=300000000/table_size=700000/ ./sysbench-cfg/benchmark.cfg
#sed -i s/run_time=1800/run_time=60/ ./sysbench-cfg/benchmark.cfg
#sed -i s/warmup_time=60/warmup_time=00/ ./sysbench-cfg/benchmark.cfg
#sed -i s/sleep_after_case=120/sleep_after_case=00/ ./sysbench-cfg/benchmark.cfg

./1_prep_dev.sh ./sysbench-cfg/benchmark.cfg 
./2_initdb.sh   ./sysbench-cfg/benchmark.cfg
./3_run.sh      ./sysbench-cfg/benchmark.cfg


#sed -i s/table_size=700000/table_size=300000000/ ./sysbench-cfg/benchmark.cfg
#sed -i s/run_time=60/run_time=1800/ ./sysbench-cfg/benchmark.cfg
#sed -i s/warmup_time=00/warmup_time=60/ ./sysbench-cfg/benchmark.cfg
#sed -i s/sleep_after_case=00/sleep_after_case=120/ ./sysbench-cfg/benchmark.cfg

#sh dovanda_tidb.sh
