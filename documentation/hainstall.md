RASPBERRY PI 2 pihole-homeassistan des de zero

Flash with Etcher the Debian Stretch-lite image into the SD
add "ssh" file (without extension) to boot partition
unmount SD, put into RPI and boot
Find out your IP with Fing app (or similar) and connect through ssh to RPI
Login with pi user and raspberry password
use passwd and change password
execute sudo raspi-config
Update raspi-config
Change locale options to ES_ES UTF.8 (Remove en_GB)
Change timezone	to Europe - Madrid
In advanced options - Expand filesystem
In Network options, Hostname set "pihole"

update, upgrade and dist-upgrade

Install PIHOLE
sudo su
curl -sSL https://install.pi-hole.net | bash
default installation with static ip and write down your password TlGnOpj9
You can change your password by: pihole -a -p
log onto http://piholeip/admin and restore config by teleporter
restore 02-pihole-dhcp.conf and 04-pihole-static-dhcp.conf manually

Install HOMEASSISTANT (https://www.home-assistant.io/docs/installation/raspberry-pi/)
set hass to boot on start (https://www.home-assistant.io/docs/autostart/systemd/)

Restore backup in /home/homeassistant/.homeassistant
sudo chmod g+w /home/homeassistant/.homeassistant -R
sudo usermod -a -G homeassistant pi

Install NetData
sudo apt-get install zlib1g-dev uuid-dev gcc make git autoconf autogen automake pkg-config
cd ~
git clone https://github.com/firehol/netdata.git --depth=1
cd netdata
sudo ./netdata-installer.sh --libs-are-really-here
sudo apt-get install net-tools nmap

Install ZeroTier
curl -s 'https://pgp.mit.edu/pks/lookup?op=get&search=0x1657198823E52A61' | gpg --import && \
if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | sudo bash; fi
sudo zerotier-cli join <networkid>


ACTUALITZAR HASS
sudo -u homeassistant -H -s
source /srv/homeassistant/bin/activate
pip3 install --upgrade homeassistant
