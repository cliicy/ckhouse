#! /bin/bash

cfg_file=$1
if [ "${cfg_file}" = "" ]; then echo -e "Usage:\n\t3_run.sh cfg_file"; exit 1; fi
if [ ! -e ${cfg_file} ]; then echo "can't find configuration file [${cfg_file}]", exit 2; fi
source ${cfg_file}

# output_dir will be used in fio.sh, so make it global
if [ "${output_dir}" == "" ];
then
        export output_dir=${result_dir}/${logfolder}-`date +%Y%m%d_%H%M%S`${case_id}
fi

echo "test output will be saved in ${output_dir}"
if [ ! -e ${output_dir} ]; then mkdir -p ${output_dir}; fi

# collect TiDB startup options / configuration / test script
cp $0 ${output_dir}
cp ${cfg_file} ${output_dir}
cp ${used_cfg} ${output_dir}

source ../lib/bench-lib

#collect_sys_info ${output_dir} ${css_status}

echo "export output_dir=${output_dir}" > ./output.dir

ssd_name=$(basename "$PWD")
sudo du -h ${app_qtable_root} > ${output_dir}/prepare.dbsize
cat /sys/block/${dev_name}/sfx_smart_features/sfx_capacity_stat >> ${output_dir}/prepare.dbsize

echo "will run workload(s) ${workload_set}"
lastwl=`echo ${workload_set} | awk '{print $NF}'`
for workload in ${workload_set};
    do
        echo "run workload ${workload}"
        sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
        # workload friendly name. it will be used in fio.sh, so make it global
        export workload_fname=${workload}
        echo -e "sfx_message starts at: " `date +%Y-%m-%d\ %H:%M:%S` "\n"  > ${output_dir}/${workload_fname}.sfx_message
        sudo chmod 666 /var/log/sfx_messages;
	tail -f -n 0 /var/log/sfx_messages >> ${output_dir}/${workload_fname}.sfx_message &
        echo $! > ${output_dir}/tail.${workload_fname}.pid
        echo "iostat start at: " `date +%Y-%m-%d\ %H:%M:%S` > ${output_dir}/${workload_fname}.iostat
        
        echo "${workload_fname} starts at: " `date +%Y-%m-%d\ %H:%M:%S` > ${output_dir}/${workload_fname}.result

        iostat -txdmc ${rpt_interval} ${disk} >> ${output_dir}/${workload_fname}.iostat &
        echo $! > ${output_dir}/${workload_fname}.iostat.pid

        (clickhouse-client -t < ${sql_path}/${workload_fname}.sql) >> ${output_dir}/${workload_fname}.result 2>&1
        #clickhouse-benchmark -c ${courrent_query} -t ${q_time} < ${sql_path}/${workload_fname}.sql >> ${output_dir}/${workload_fname}.result 2>&1

        echo -e "\nsfx_messages ends at: `date +%Y-%m-%d_%H:%M:%S`\n"  >> ${output_dir}/${workload_fname}.sfx_message
        echo ${output_dir}/tail.${workload_fname}.pid
        kill `cat ${output_dir}/tail.${workload_fname}.pid`
        rm -f ${output_dir}/tail.${workload_fname}.pid
        echo -e "\niostat ends at: " `date +%Y-%m-%d_%H:%M:%S` >> ${output_dir}/${workload_fname}.iostat
        echo -e "\n${workload_fname}" "\nends at: " "`date +%Y-%m-%d_%H:%M:%S`" >> ${output_dir}/${workload_fname}.result
        echo ${output_dir}/${workload_fname}.iostat.pid
        kill `cat ${output_dir}/${workload_fname}.iostat.pid`
        rm -f ${output_dir}/${workload_fname}.iostat.pid
        sleep ${sleep_after_case}

    done

get_clickhouse_csv ${output_dir}
get_clickhouse_dbsize ${output_dir}

qtable_size=`tail -n 3 ${output_dir}/prepare.dbsize | head -1 | awk '{print $1}'`
gen_benchinfo_clickhouse ${ssd_name} ${qtable_size} ${output_dir}
