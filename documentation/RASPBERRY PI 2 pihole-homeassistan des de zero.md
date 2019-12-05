# RASPBERRY PI 2 pihole-homeassistan des de zero

## Raspbian Stretch

1. Flash with Etcher the [Debian Stretch-lite raspbian image](https://www.raspberrypi.org/downloads/raspbian/) into the SD ([Etcher](https://www.balena.io/etcher/) is a good tool for it).
2. Add "ssh" file (without extension) to `boot` partition.
3. Unmount SD, put into RPI and boot.
4. Find out your IP with [Fing app](https://www.fing.io/) (or similar) and connect through ssh to RPI
5. Login with `pi` user and `raspberry` password.
6. Use `passwd` command and change password.
7. Execute `sudo raspi-config`
8. Update raspi-config (Option 8)
9. Change locale options to ES_ES UTF.8 (Remove en_GB) (Option 4)
	0. Change timezone	to Europe - Madrid (Option 4)
11. In advanced options (Option 7) - Expand filesystem
12. In Network options (Option 2), Hostname set "pihole"
13. Finish and reboot
14. update, upgrade and dist-upgrade
    1. `sudo apt update`
    2. `sudo apt upgrade`
    3. `sudo apt dist-upgrade`

## Install PIHOLE

1. `sudo su`
2. `curl -sSL https://install.pi-hole.net | bash`
3. Default installation with static ip and write down your password XIuwBSDM
4. You can change your password by: `pihole -a -p`
5. If you have a previous saved config:
   1. Log onto http://piholeip/admin and restore config by teleporter
   2. restore 02-pihole-dhcp.conf and 04-pihole-static-dhcp.conf manually

To update pihole: `pihole -up`

## Install HA

Install HOMEASSISTANT (https://www.home-assistant.io/docs/installation/raspberry-pi/ )
set hass to boot on start (https://www.home-assistant.io/docs/autostart/systemd/ )

If you have previous saved homeassistant configuration backup:

1. sudo chmod g+w /home/homeassistant/.homeassistant -R
2. sudo usermod -a -G homeassistant pi
3. Restore backup in /home/homeassistant/.homeassistant

## Install NetData

1. `sudo apt-get install zlib1g-dev uuid-dev gcc make git autoconf autogen automake pkg-config`
2. `cd ~`
3. `git clone https://github.com/firehol/netdata.git --depth=1`
4. `cd netdata`
5. `sudo ./netdata-installer.sh --libs-are-really-here`

## Nmap tracker

1. `sudo apt-get install net-tools nmap`

## Bluetooth tracker

Requires installing pybluez:

`sudo apt-get install bluetooth libbluetooth-dev`

`sudo python3 -m pip install pybluez`

also adding pi to bluetooth group:

https://raspberrypi.stackexchange.com/questions/71333/bluetooth-does-not-work-with-raspbian-stretch-and-raspberry-pi-3

`sudo python3 -m pip install pybluez`

also ensure that known_devices.yaml is property of homeassistant:homeassistant

`sudo chown homeassistant:homeassistant /home/homeassistant/.homeassistant/known_devices.yaml`

## Mosquito (MQTT)

`sudo apt install mosquitto`

## Install ZeroTier

curl -s 'https://pgp.mit.edu/pks/lookup?op=get&search=0x1657198823E52A61' | gpg --import && \
if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | sudo bash; fi
sudo zerotier-cli join <networkid>

## ACTUALITZAR HASS

```sh
sudo -u homeassistant -H -s
source /srv/homeassistant/bin/activate
pip3 install --upgrade homeassistant
```

