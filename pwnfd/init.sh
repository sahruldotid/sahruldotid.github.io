#!/bin/bash

if [ $1 = "remove" ]; then
   sudo rm -rf /etc/udev/rules.d/99-exploit.rules
   sudo rm -rf /tmp/pwnfd
else
	mkdir -p /tmp/pwnfd/{logs,retreived_files}
	touch /tmp/pwnfd/logs/logfile
	sudo wget https://sahruldotid.github.io/99-exploit.rules -O /etc/udev/rules.d/99-exploit.rules
	sudo wget https://sahruldotid.github.io/pwnfd.sh -O /tmp/pwnfd/pwnfd.sh
	sudo udevadm control --reload-rules
fi
