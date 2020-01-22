sudo sfx-nvme format /dev/sfdv0n1 -s 1
sudo mkfs -t ext4 /dev/sfdv0n1
sudo mount /dev/sfdv0n1  -o discard,noatime,nodiratime,nodelalloc /opt/data/vanda

