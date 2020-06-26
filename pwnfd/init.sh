#!/bin/bash

if [ $1 = "remove" ]; then
   sudo rm -rf /etc/udev/rules.d/99-exploit.rules
   sudo rm -rf /tmp/pwnfd
   echo "pwnfd removed :)"
else
	mkdir -p /tmp/pwnfd/{logs,retrieved_files}
	touch /tmp/pwnfd/logs/logfile
	sudo wget https://sahruldotid.github.io/pwnfd/99-exploit.rules -O /etc/udev/rules.d/99-exploit.rules
	sudo wget https://sahruldotid.github.io/pwnfd/pwnfd.sh -O /tmp/pwnfd/pwnfd.sh
	sudo udevadm control --reload-rules
	echo "pwnfd installed :)"
fi
