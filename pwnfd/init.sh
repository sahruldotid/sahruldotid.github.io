#!/bin/bash

if [[ $1 = "remove" ]]; then
   sudo rm -rf /etc/udev/rules.d/99-mas_syah.rules
   sudo rm -rf /root/pwnfd
   echo "pwnfd removed :)"
else
	echo "Creating files and directory"
	mkdir -p /root/pwnfd/{logs,retrieved_files} &
	touch /root/pwnfd/logs/logfile &
	echo "Downloading script"
	sudo wget https://sahruldotid.github.io/pwnfd/99-mas_syah.rules -O /etc/udev/rules.d/99-mas_syah.rules &
	sudo wget https://sahruldotid.github.io/pwnfd/pwnfd.sh -O /root/pwnfd/pwnfd.sh &
	echo "Set permission"
	sudo chmod +x /root/pwnfd/pwnfd.sh &
	echo "Load rules"
	sudo udevadm control --reload-rules &
	echo "pwnfd installed :)"
	echo "The copied files will be placed at /root/pwnfd/retrieved_files/"
	echo "Enjoy :)"
fi
