#!/bin/bash 
# return the state of remote_admin_allowed, teamviewer_enabled, openvpn_enabled and handle

if [ ! -f /etc/xsce/xsce.env ]; then
  exit 1 # this file should exist, do not proceed
fi

cat /etc/xsce/xsce.env|grep REMOTE_ADMIN_ALLOWED>/dev/null
if [ $? -ne 0 ]; then
  echo "REMOTE_ADMIN_ALLOWED=False" >> /etc/xsce/xsce.env
  remote_admin_allowed=False
fi
remote_admin_allowed=`cat /etc/xsce/xsce.env |grep REMOTE_ADMIN_ALLOWED | cut -d"=" -f2`

if [ ! -f /etc/xsce/config_vars.yml ]; then
  # do not error out and keep the console from coming up
  openvpn_enabled=False
  teamviewer_enabled=False
  exit 0
fi
openvpn_enabled=`cat /etc/xsce/config_vars.yml|grep openvpn_enabled|cut -d":" -f2`
if [ -z "$openvpn_enabled" ]; then
   openvpn_enabled=False
else
   openvpn_enabled=${openvpn_enabled# }
fi

teamviewer_enabled=`cat /etc/xsce/config_vars.yml|grep teamviewer_enabled|cut -d":" -f2`
if [ -z "$teamviewer_enabled" ]; then
   teamviewer_enabled=False
else
   teamviewer_enabled=${teamviewer_enabled# }
fi

# get the handle
if [ -f /etc/xsce/handle ]; then
  handle=`cat /etc/xsce/handle`
else
  echo "default handle" > /etc/xsce/handle
  handle="default handle"
fi

