# cpworker2 with k3s

This node will host: cpworker2 of k8s cluster
Hostname: cpworker2, Raspberry PI 4 4GB, 128 GB SDCard
We use Raspberry PI Imager to load the following image on SD Card Ubuntu Server 23.10, ARM 64Bit
* SDCard Image write on SDCard
* plug-in SD Card into your Mac
* open Raspberry PI Imager on your MacOS, if not installed, install it
* choose OS: Ubuntu Server 23.10 64Bit
* Enter in Raspberry PI Imager Everything we need: Hostname, username ubuntu with password, Keyboard layout, enable ssh with password 
* write everything to MASS disk
* Set SDCard 
* press write
* Change into SDCard and check if new data in written
* remove SDCard from Slot and plug-in in again

Now we configre the network
```bash
cd /Volumes/system-boot/
df- k

vi /Volumes/system-boot/network-config
network:
  version: 2

  ethernets:
    eth0:
      addresses:
        - 192.168.178.102/24
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
#          password: "YOURPASSWORD"
```

Plug-in SDCard into PI4 stecken, plug-in Ethernet cable and USB_C power cable. The third PI is booting.
Login in worker2;
```bash
ssh ubuntu@192.168.178.102
# ssh ubuntu@cpworker2
User: ubuntu Password: YOURPASSWORD

# check if old hostname exits
sudo cat /etc/hostname
   change ubuntu in cpworker2
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

cpworker2 is ready to continue with tools installation.

## Install main components like kubectl, Helm, docker and k3s agent

login to cpworker2
```bash
ssh ubuntu@cpworker2
# How much storage do we have available in cpmaster
df -k
# Memory check
free
# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
#Helm 3 (optional)
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
# docker (optional)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh 
# Rootless setup (optional)
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
# set env variables
source ~/.bashrc
# configure firewall
sudo ufw allow 6443/tcp
sudo ufw allow 443/tcp
```

The Worker token is: YOURTOKEN

We have all main components installed.
Add ssh key to cpworker2:
* copy public key `/YOURPATH/k3s-key.pub` into clipboard and store on cpworker2 in `.ssh/authorized_keys`

Now exit and you can login with ssh key
```bash
# login via ssh key
ssh -i ~/keys/k3s-key ubuntu@cpworker2
```

cpworker2 is ready, add it to master
Install k3s on all workers nodes, cpworker1-cpworker3
Adapt K3S_URL and K3S_TOKEN to your control plane node cpmaster hostname/IP and node token, respectively
```bash
curl -sfL https://get.k3s.io | K3S_URL=https://cpmaster:6443 K3S_TOKEN=YOURTOKEN sh -s - --docker
``` 
Check installation

On worker node
```bash
sudo systemctl status k3s-agent
``` 

On control plane node the cpmaster node
```bash
ssh -i ~/keys/k3s-key ubuntu@cpmaster
sudo systemctl status k3s
sudo kubectl get nodes
# Should see something like below
#NAME                 STATUS   ROLES                  AGE   VERSION
#NAME        STATUS   ROLES                  AGE     VERSION
#cpmaster    Ready    control-plane,master   46h   v1.27.7+k3s2
#cpworker2   Ready    <none>                 26s   v1.27.7+k3s2
#cpworker1   Ready    <none>                 47m   v1.27.7+k3s2
``` 

## Last step is to allow some commands to not enter passwords:
```bash
ssh -i ~/keys/k3s-key ubuntu@cpworker2
sudo cp /etc/sudoers /etc/sudoers.bak
sudo vi /etc/sudoers
# At the end of the file
ubuntu cpworker2 = (root) NOPASSWD: /usr/sbin/shutdown
ubuntu cpworker2 = (root) NOPASSWD: /usr/bin/systemctl
ubuntu cpworker2 = (root) NOPASSWD: /sbin/reboot
```
cpworker2 is ready, now start to prepare [cpworker3](cpworker3.md).