#!/bin/bash
LOG_FILE="/tmp/pwnfd/logs/logfile"
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)
DST="/tmp/pwnfd/retreived_files/`date +"%d-%m-%Y---%H:%M:%S"`"
mkdir $DST
for _device in /sys/block/*/device; do
    if echo $(readlink -f "$_device")|egrep -q "usb"; then
        _disk=$(echo "$_device" | cut -f4 -d/)
        mkdir /tmp/"$_disk"
		mount /dev/"$_disk" /tmp/"$_disk"
		cp -R /tmp/"$_disk"/* $DST
		umount /tmp/"$_disk"
		rm -r /tmp/"$_disk"
		echo "Copy success using $_disk at `date`"
    fi
done
exit 0
