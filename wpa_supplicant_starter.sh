#!/bin/bash
#submited by Shiru

CONFIG=/etc/wpa_supplicant.conf

killall wpa_supplicant >/dev/null 2>/dev/null
killall dhcpcd >/dev/null 2>/dev/null

if [ $EUID -ne 0 ]; then
   echo "You need to be root to run this" 1>&2
   exit 1
fi

if [ ! -f $CONFIG ]; then
    echo "Configuration file not found at: $CONFIG" 1>&2
    exit 2
fi

echo -n "Starting wpa_supplicant... "
wpa_supplicant -i wlan0 -B -Dwext -c $CONFIG

if [ $? -ne 0 ]; then
    echo "Failed"
    exit 3
fi

echo "Done"

echo -n "Starting dhcp... "

dhcpcd wlan0 >/dev/null 2>/dev/null

if [ $? -ne 0 ]; then
    echo "Failed"
    exit 4
fi

echo "Done"

exit 0
