#!/bin/bash
DEVICE="$1"
echo $DEVICE > /tmp/pwnfd/logs/logfile
LOG_FILE="/tmp/pwnfd/logs/logfile"
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)
DST="/tmp/pwnfd/retrieved_files/`date +"%d-%m-%Y---%H:%M:%S"`"
mkdir $DST
mkdir -p /mnt/pwnfd"$DEVICE"
mount -t vfat "$DEVICE" /mnt/pwnfd"$DEVICE"
cp -R /mnt/pwnfd"$DEVICE"/* $DST
chmod 777 -R $DST

umount /mnt/pwnfd"$DEVICE"
rm -r /mnt/pwnfd"$DEVICE"


echo "Copy to $DEVICE  >> Done !"
exit 0
