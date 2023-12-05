# cpmaster with k3s

This node will host: cpmaster of k8s cluster

Hostname: cpmaster, Raspberry PI 4 8GB, 128 GB SDCard

I use Raspberry PI Imager to load the following image on SD Card:  Ubuntu Server 23.10, ARM 64Bit
* SDCard Image write on SDCard
* plug-in SD Card into your Mac
* open Raspberry PI Imager on your MacOS, if not installed, install it
* choose OS: Ubuntu Server 23.10 64Bit
* Enter in Raspberry PI Imager everything we need: Hostname, username ubuntu with password, Ke, yboard layout, enable ssh with password 
* write everything to MASS disk
* Set SDCard 
* press write
* Change into SDCard and check if new data in written
* remove SDCard from Slot and plug-in in again

Now we configre the network:
```bash
cd /Volumes/system-boot/
df- k
# Edit Network
vi /Volumes/system-boot/network-config
network:
  version: 2

  ethernets:
    eth0:
      addresses:
        - 192.168.178.100/24
      gateway4: 192.168.178.1
      nameservers:
        addresses: [192.168.178.1]
      dhcp4: true
      optional: true

#  wifis:
#    wlan0:
#      dhcp4: true
#      optional: true
#      access-points:
#        SSID:
#          password: "Your Passsword"
```

The SD Card is prepared.
Plug the SDCard into the first PI4  (master), plug-in Ethernet cable and power cable.
Switch on power and the first raspberry PI (the master) will boot.
Login into master:
```bash
ssh ubuntu@192.168.178.100
# ssh ubuntu@cpmaster
User: ubuntu Password: YOURPASSWORD

# check if old hostname exits
sudo cat /etc/hostname
   change ubuntu in cpmaster
sudo vi /etc/hosts
192.168.178.100 cpmaster cpmaster.local
192.168.178.101 cpworker1 cpworker1.local
192.168.178.102 cpworker2 cpworker2.local
192.168.178.103 cpworker3 cpworker3.local

# Update
sudo apt-get update
sudo apt-get upgrade
sudo reboot
``` 

cpmaster is ready to continue with tools installation.

## Install main components like kubectl, Helm, docker and k3s server

login to raspberrypi pi cpmaster
```bash
ssh ubuntu@cpmaster
# How much storage do we have available in cpmaster
df -k
# Memory check
free
# follow k3s installtion from here https://gist.github.com/syncom/7c6e90708bc28cc9ede2c3245c203e32
# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
#Helm 3
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
# docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh 
# Rootless setup
sudo sh -eux <<EOF
# Install newuidmap & newgidmap binaries
apt-get install -y uidmap
EOF
dockerd-rootless-setuptool.sh install
# Add the following lines to the end of ~/.bashrc
# docker
vi ~/.bashrc
export PATH=/usr/bin:$PATH
export DOCKER_HOST=unix:///run/user/1000/docker.sock

source ~/.bashrc

# install k3s
curl -sfL https://get.k3s.io | sh -s - --docker
# check installation
sudo systemctl status k3s
sudo kubectl get nodes -o wide
# configure firewall
sudo ufw allow 6443/tcp
sudo ufw allow 443/tcp
# get token for the worker setup
sudo cat /var/lib/rancher/k3s/server/node-token
```

Write down the token, we need it later for k3s agent installtion.
```bash
Worker token: YOUR_TOKEN
```

We have all main components installed.

Create a key pair on your desktop:
```bash
ssh-keygen
```

This key if for ssh login via key. 
* copy private key `/YOURPATH/k3s-key` on your desktop
* copy public key `/YOURPATH/k3s-key.pub` into clipboard and store on cpmaster in `.ssh/authorized_keys`

Now, you can login with ssh key
```bash
# login via ssh key
ssh -i ~/keys/k3s-key ubuntu@cpmaster
```

## Last step is to allow some commands to not enter passwords:
```bash
ssh -i ~/keys/k3s-key ubuntu@cpmaster
sudo cp /etc/sudoers /etc/sudoers.bak
sudo vi /etc/sudoers
# At the end of the file
ubuntu cpmaster = (root) NOPASSWD: /usr/sbin/shutdown
ubuntu cpmaster = (root) NOPASSWD: /usr/bin/systemctl
ubuntu cpmaster = (root) NOPASSWD: /sbin/reboot
```
cpmaster is ready, now start to prepare [cpworker1](cpworker1.md).