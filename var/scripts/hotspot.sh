#!/usr/local/bin/bash

service network-manager stop
sleep 1

pkill -15 nm-applet
sleep 1

ifconfig wlp2s0 down             #wlan0 - the name of your wireless adapter
sleep 1

iw phy phy0 interface add new0 type station
iw phy phy0 interface add new1 type __ap
sleep 2

ifconfig new0 down
macchanger --mac 00:11:22:33:44:55 new0
ifconfig new1 down
macchanger --mac 00:11:22:33:44:66 new1
ifconfig new0 up
ifconfig new1 up

ifconfig new1 192.168.0.101 up  #192.168.0.101 - the same IP defined for router in 'udhcpd.conf' file
hostapd /etc/hostapd.conf &
sleep 2

service udhcpd start

wpa_supplicant -inew0 -c/etc/wpa_supplicant.conf &
sleep 10

udhcpc -i new0

echo "1" >/proc/sys/net/ipv4/ip_forward
iptables --table nat --append POSTROUTING --out-interface new0 -j MASQUERADE
iptables --append FORWARD --in-interface new1 -j ACCEPT
