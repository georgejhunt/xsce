# Notes On Generating Raspian XSCE

```
dd if=2016-05-27-raasspbian-jessie.img of=/dev/<sdd> bs=4M
```
* Put into rpi3
* during startup the SD card will resize
* Menu->Preferences->Raspberry Pi config->localization->select keyboard
```
#!/bin/bash -x
# required to start loading XSCE
set -e
#source /root/tools/ssdebian
#source /root/.bashrc

# use the normal ansible install to bring in the dependencies
apt-get update
apt-get upgrade
apt-get install -y ansible mlocate vim
apt-get remove -y ansible

# go fetch a known and more recent ersion of ansible
cd /root
git clone https://github.com/ansible/ansible.git --branch stable-2.1 --recursive

cd /root/ansible
python setup.py install

cd /opt
mkdir schoolserver
cd schoolserver
git clone https://github.com/georgejhunt/xsce --branch debian
cd xsce
./install-console
```
