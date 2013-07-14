#!/bin/sh
#submited by shiru
################################################################################​
# ipfw_dynamic.sh                                       
################################################################################​

#
# Get current dynamic firewall rules
# IP or port can be specified
#
# Example: 
# Get all rules of port 80:                         ipfw_dynamic.sh -p 80
# Repeat all rules for 443 at IP 193.110.81.110:    ipfw_dynamic.sh repeat -p 443 -ip 193.110.81.110 
# Repeat all rules:                                 ipfw_dynamic.sh repeat
#

################################################################################​
#                                  FUNCTIONS                                 
################################################################################​
ipfw_dynamic()
{
    local ip="$1"
    local port="$2"
    local awkp="{print \$7,\"-\",\$11}"
    
    clear
    echo "** DYNAMIC RULES: $(date +%T) **"
    
    if [ ! "$ip" = "" ] && [ ! "$port" = "" ]; then    
        awkp="{if (\$11 == \"$port\" && \$7 == \"$ip\") print \$7,\"-\",\$11}"
        echo "   Connections for $ip on port $port"
        echo
    elif [ ! "$ip" = "" ]; then
        awkp="{if (\$7 == \"$ip\") print \$11}"
        echo "   Ports used by $ip"
        echo
    elif [ ! "$port" = "" ]; then 
        awkp="{if (\$11 == \"$port\") print \$7}"
        echo "   IPs using port $port"
        echo
    else
        echo "   All rules"
        echo    
    fi    

    eval "ipfw -d list | grep 'tcp\|udp' | grep -v any | awk '$awkp' | sort | uniq -c | sort -nr"
}

print_usage()
{
    echo "usage: ipfw_dynamic [ -ip -p repeat ]"
    echo "  options:"
    echo "  -ip            ip address"
    echo "  -p             port"
    echo "  repeat         run until q is pressed"
}

run()
{
    local repeat=$1
    local ip="$2"
    local port="$3"    
    local keypress=""    
    
    ipfw_dynamic "$ip" "$port"
    
    while [ $repeat = true ]; do
        ipfw_dynamic "$ip" "$port"    
        echo
        echo "Press 'q' to exit"        
        keypress=`stty -icanon min 0 time 30; dd bs=1 count=1 2>/dev/null` 
        [ "$keypress" = "q" ] && repeat=false
    done    
}

main()
{    
    local port=""
    local ip=""    
    local repeat=false
    local option="$1"
    local wrong_format=false
    local i=1    

    [ ! "$6" = "" ] && print_usage && exit 0
    while [ ! "$option"    = "" ]; do            
        if [ "$ip" = "set" ]; then
            ip="$option"
        elif [ "$port" = "set" ]; then
            port="$option"
        elif [ "$option" = "-ip" ]; then
            ip="set" 
        elif [ "$option" = "-p" ]; then
            port="set"
        elif [ "$option" = "repeat" ]; then
            repeat=true
        else
            wrong_format=true
            break
        fi
        i=`expr $i + 1`    
        eval "option=\"\$$i\""
    done
    
    [ $wrong_format = true ] && print_usage || run $repeat "$ip" "$port"
    exit 0
}


################################################################################​
#                               Start script                                   
################################################################################​
#
# Maximum 5 parameters: -ip, ip, -p, port, repeat
# $6 not empty results in an error
main "$1" "$2" "$3" "$4" "$5" "$6" 
