#!/bin/bash

URL=`curl --silent "https://api.github.com/repos/$1/releases/latest" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/' | grep linux | grep amd64`
wget $URL
