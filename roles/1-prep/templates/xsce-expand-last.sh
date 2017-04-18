#!/bin/bash 
# script to resize the last partition

LAST=`fdisk -l | grep /dev/sda | tail -n1 | cut -d' ' -f1`
LAST_NO=${LAST: (-1)}
DEVICE=${LAST:0:-1}

parted -s -f $DEVICE resizepart $LAST_NO 100%
resize2fs $LAST
