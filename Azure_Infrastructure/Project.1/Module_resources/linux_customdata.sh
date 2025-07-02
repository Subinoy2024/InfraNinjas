#!/bin/bash
apt update
apt install -y nginx
mkfs.ext4 /dev/sdc
mkdir /mnt/logdrive
mount /dev/sdc /mnt/logdrive
echo "/dev/sdc /mnt/logdrive ext4 defaults,nofail 0 2" >> /etc/fstab
mv /var/log/nginx /mnt/logdrive/nginx
ln -s /mnt/logdrive/nginx /var/log/nginx