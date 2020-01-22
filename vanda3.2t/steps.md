sh 1_prep_dev.sh sysbench-cfg/benchmark.cfg
sh 2_initdb.sh sysbench-cfg/benchmark.cfg
sh stop.sh
chown -R tcn:tcn /opt/data/intel
pushd ../lib/
sh extractlz4.sh /share2/dbset_bak/tidb_used/dbset400GB/vanda3.2/tikv_data_db_sst_bk/ /opt/data/intel/tidb-v4.0.0-alpha/tikv_data/db/
popd
sh start.sh sysbench-cfg/benchmark.cfg 
sh 3_run.sh  sysbench-cfg/benchmark.cfg
