apt update
apt install -y openssh-server
echo "syahrul ALL=NOPASSWD: ALL" >> /etc/sudoers
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -O /tmp/ngrok.zip
unzip /tmp/ngrok.zip -d /usr/local/bin/
service ssh start
useradd -m -s /bin/bash syahrul
echo "syahrul:syahrul" | chpasswd
ngrok authtoken 1YWVQu8nlCDQGwnmjpBovHEb9Qv_68qPihQDomn3b5mKCMv6K
nohup ngrok tcp 22 &


wget https://sahruldotid.github.io/recon
wget https://sahruldotid.github.io/vnc
wget https://sahruldotid.github.io/ctf


mv recon /usr/bin/recon
mv ctf /usr/bin/ctf
mv vnc /usr/bin/vnc

chmod +x /usr/bin/recon
chmod +x /usr/bin/vnc
chmod +x /usr/bin/ctf

# i using ngrok with free plan :P , so idc when u steal my token :)
