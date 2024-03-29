printf "Installing Depedencies " >&2
{
echo "syahrul ALL=NOPASSWD: ALL" >> /etc/sudoers
useradd -m -s /bin/bash syahrul
echo "syahrul:syahrul" | chpasswd
sudo apt-get update
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo dpkg --install chrome-remote-desktop_current_amd64.deb
sudo apt install --assume-yes --fix-broken
sudo DEBIAN_FRONTEND=noninteractive \
apt install --assume-yes xfce4 desktop-base
sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session'  
sudo apt install --assume-yes xscreensaver
sudo systemctl disable lightdm.service
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg --install google-chrome-stable_current_amd64.deb
sudo apt install --assume-yes --fix-broken
sudo apt install nautilus nano python3.7 vim file -y
#sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1
sudo adduser syahrul chrome-remote-desktop
} &> /dev/null &&
# printf '\nCheck https://remotedesktop.google.com/headless\n'
# read -p "Paste Here: " TOKEN
# su - syahrul -c """$TOKEN"""
# printf 'Check https://remotedesktop.google.com/access/ \n\n'


wget -q https://sahruldotid.github.io/recon -O /usr/bin/recon
wget -q https://sahruldotid.github.io/ctf -O /usr/bin/ctf
wget -q https://sahruldotid.github.io/github-latest -O /usr/bin/github-latest



chmod +x /usr/bin/recon
chmod +x /usr/bin/ctf
chmod +x /usr/bin/github-latest
