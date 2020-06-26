#!/bin/bash
DEVICE="$1"
echo $DEVICE > /root/pwnfd/logs/logfile
LOG_FILE="/root/pwnfd/logs/logfile"
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)
DST="/root/pwnfd/retrieved_files/`date +"%d-%m-%Y___%H:%M:%S"`"
mkdir $DST
mount "$DEVICE" /mnt
cp -R /mnt/* $DST
chmod 777 -R $DST
umount /mnt
echo "Copy from $DEVICE to $DST >> Done !"
exit 0
