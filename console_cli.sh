#!/bin/bash

# copy var files to /etc/xsce for subsequent use

./install-init

# if not the first run, repo location is here

if [ -f /etc/xsce/xsce.env ]
then
  . /etc/xsce/xsce.env
  cd $XSCE_DIR
fi

PLAYBOOK="xsce-from-console.yml"
INVENTORY="ansible_hosts"
SELINUX_BEFORE=""
SELINUX_AFTER=""

if [ ! -f $PLAYBOOK ]
then
 echo "XSCE Playbook not found."
 echo "Please run this command from the top level of the git repo."
 echo "Exiting."
 exit 1
fi

if [ -f /etc/selinux/config ]
then
 SELINUX_BEFORE=`cat /etc/selinux/config | gawk -F= '/^SELINUX=/{ print $2 }'`
fi

export ANSIBLE_LOG_PATH="$XSCE_DIR/xsce-install.log"
ansible-playbook -i $INVENTORY $PLAYBOOK --connection=local

if [ -f /etc/selinux/config ]
then
 SELINUX_AFTER=`cat /etc/selinux/config | gawk -F= '/^SELINUX=/{ print $2 }'`
fi

if [ "$SELINUX_BEFORE" != "$SELINUX_AFTER" ]; then
  echo "Rebooting ..."
  reboot
fi
