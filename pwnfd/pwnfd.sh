#!/bin/bash
DEVICE="$1"
LOG_FILE="/tmp/pwnfd/logs/logfile"
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)
DST="/tmp/pwnfd/retreived_files/`date +"%d-%m-%Y---%H:%M:%S"`"
mkdir $DST
mkdir /tmp/pwnfd/"$DEVICE"
mount -t vfat /dev/"$DEVICE" /tmp/pwnfd/"$DEVICE"
cp -R /tmp/pwnfd/"$DEVICE"/* $DST
chmod 777 -R $DST

umount /tmp/pwnfd/"$DEVICE"
rm -r /tmp/pwnfd/"$DEVICE"


echo "Copy to $DEVICE  >> Done !"
exit 0


# for _device in /sys/block/*/device; do
#     if echo $(readlink -f "$_device")|egrep -q "usb"; then
#         _disk=$(echo "$_device" | cut -f4 -d/)
#         mkdir /tmp/"$_disk"
# 		mount /dev/"$_disk" /tmp/"$_disk"
# 		cp -R /tmp/"$_disk"/* $DST
# 		chmod 777 /tmp/"$_disk"/*
# 		umount /tmp/"$_disk"
# 		rm -r /tmp/"$_disk"
# 		echo "Copy success using $_disk at `date`"
#     fi
# done
