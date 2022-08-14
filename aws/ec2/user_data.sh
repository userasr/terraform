#!/bin/bash
{
#Install Docker
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo usermod -aG docker ec2-user

#Mount Data Volume
sudo mkfs /dev/xvdb
sudo mkdir /data
sudo mount -t ext4 /dev/xvdb /data
sudo cp /etc/fstab /etc/fstab.bak1
sudo echo "/dev/xvdb /data ext4 defaults,inode_readahead_blks=128,data=writeback,notime,nodev,commit=60,nofail">> /etc/fstab
#Mount Log Volume
sudo mkfs /dev/xvdc
sudo mkdir /log
sudo mount -t ext4 /dev/xvdc /log
sudo cp /etc/fstab /etc/fstab.bak2
sudo echo "/dev/xvdc /log ext4 defaults,inode_readahead_blks=128,data=writeback,notime,nodev,commit=60,nofail">> /etc/fstab

#sudo reboot
} 2>&1 | tee /tmp/bootstrap.log
