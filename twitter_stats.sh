#!/bin/bash
#
# Send system info to twitter.
#
#submited by matt
# Requires twidge application and lm-sensors

CPUTEMP=$(sensors | grep -i "cpu temp" | awk '{print $3}' | sed 's/+//' | sed 's/°C//')
MBTEMP=$(sensors | grep -i "mb temp" | awk '{print $3}' | sed 's/+//' | sed 's/°C//')
FREEMEM=$(free -m | head -2 | sed 's/Mem://' | awk '{print $3}' | grep '[^a-z A-Z]')
USERS=$(who | wc -l)

# post tweet
twidge update "$USERS User(s) - CPU Temp: $CPUTEMP*c - MB Temp: $MBTEMP*c - Free mem: $FREEMEM mb"
