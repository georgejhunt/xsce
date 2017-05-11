#!/bin/bash -x
# create an override which enables/disables remote admin, attach to button

# get the information about whether openvpn or teamviewer are enabled
curdir=$(dirname $0)
source $curdir/status.inc

# error if no control parameter
if [ $# -ne 1 ]; then
   exit 1
fi
if [ "$1" == "True" ]; then

  # error if the variable does not exist
  grep REMOTE_ADMIN_ALLOWED /etc/xsce/xsce.env
  if [ $? -ne 0 ];then
     exit 1
  fi
  sed -i -e 's/^REMOTE_ADMIN_ALLOWED.*/REMOTE_ADMIN_ALLOWED=True/' /etc/xsce/xsce.env
  if [ "$openvpn_enabled" == "True" ];then
     if [ ! -f /etc/openvpn/xsce-vpn.conf ]; then
        # first blast the gui_vpn_handle to places it needs to be
        HANDLE=`cat /etc/xsce/config_vars.yml|grep gui_vpn_handle|cut -d":" -f2` 
        HANDLE=${HANDLE# }
        echo $HANDLE > /etc/xsce/handle
        systemctl enable openvpn@xscenet
        systemctl start openvpn@xscenet
     fi
  fi
  if [ "$teamviewer_enabled" == "True" ];then
     systemctl enable teamviewer
     systemctl start teamviewer
  fi
else
  sed -i -e 's/^REMOTE_ADMIN_ALLOWED.*/REMOTE_ADMIN_ALLOWED=False/' /etc/xsce/xsce.env
# for demo of this GUI over the vpn, don't stop the service
  systemctl stop openvpn@xscenet.service
  systemctl disable openvpn@xscenet.service
  systemctl stop teamviewer
  systemctl disable teamviewer
fi
exit 0

