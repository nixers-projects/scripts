#submited by venam
#require iptables
case "$1" in
start)
ifconfig eth0 up
ifconfig eth0 192.168.1.1
iptables --table nat --append POSTROUTING --out-interface wlan0 -j MASQUERADE
iptables --append FORWARD --in-interface eth0 -j ACCEPT
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "set other computers in the range of"
echo "192.168.1.1 255.255.255.0"
echo "subnet : 255.255.255.255"
echo "gateway 192.168.1.1"
echo "dns 192.168.0.1" #this is my router's ip, you should use yours or another dns server but it's better to use the router
;;
stop)
echo 0 > /proc/sys/net/ipv4/ip_forward
ifconfig eth0 down
iptables --table nat --delete POSTROUTING --out-interface wlan0 -j MASQUERADE
;;
*)
echo "usage: $0 {start|stop}"
;;
esac
