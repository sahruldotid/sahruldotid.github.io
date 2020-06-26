#!/bin/bash
DEVICE="$1"
echo $DEVICE > /tmp/pwnfd/logs/logfile
LOG_FILE="/tmp/pwnfd/logs/logfile"
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)
DST="/tmp/pwnfd/retreived_files/`date +"%d-%m-%Y---%H:%M:%S"`"
mkdir $DST
mkdir -p /tmp/pwnfd"$DEVICE"
mount -t vfat "$DEVICE" /tmp/pwnfd"$DEVICE"
cp -R /tmp/pwnfd"$DEVICE"/* $DST
chmod 777 -R $DST

umount /tmp/pwnfd"$DEVICE"
rm -r /tmp/pwnfd"$DEVICE"


echo "Copy to $DEVICE  >> Done !"
exit 0
