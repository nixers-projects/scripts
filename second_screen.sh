#!/bin/bash
#submited by matt
# enable second display with xrandr

# check VGA is connected
VGA=`xrandr | grep VGA1 | awk '{print $2}'`

if [ $1 == '-1' ] ; then
        echo -e "\n[+] Disabling Second Display\n"
        sleep 1
        xrandr --output LVDS1 --auto --output VGA1 --off
        sleep 1
else
    if [ $1 == '-2' ] ; then
        if [ $VGA == 'connected' ] ; then
            echo -e "\n[+] Enabling Second Display\n"
            sleep 1
            xrandr --output LVDS1 --auto --output VGA1 --auto --right-of LVDS1
            sleep 1
        fi
    fi
fi
