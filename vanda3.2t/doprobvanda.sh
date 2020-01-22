export css_util_dir=/home/tcn/software/vanda/rc_3.0.5.0-r49582/bin_pkg/centos7.5/sfx_qual_suite
export css_status=${css_util_dir}/css-status.sh
export initcard="./initcard.sh --blk --cl"

pushd ${css_util_dir}
#sudo sfx-nvme format /dev/sfdv0n1
sudo sfx-nvme format /dev/sfdv0n1 -s 1
#sudo ./initcard.sh --blk --cl
#sudo ./initcard.sh --blk --cl  --capacity=6400
popd
