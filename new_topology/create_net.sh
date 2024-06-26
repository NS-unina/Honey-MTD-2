#!/bin/bash
source functions.sh


vlans1=("vlan11" "vlan12" "vlan13" "vlan16" "vlan17" "vlan18")
vlans2=("vlan21" "vlan22" "vlan23" "vlan26" "vlan27")
vlans3=("vlan31" "vlan32" "vlan33" "vlan36" "vlan37")

setup_ovs_bridge "br0_lan1" "br1_lan1" "br0_lan2" "br1_lan2" "br0_lan3" "br1_lan3" "br_wan"

create_ovs_bridge "br_wan" "3a:4d:a7:05:2a:48" 
create_ovs_bridge "br0_lan1" "3a:4d:a7:05:2a:45"
create_ovs_bridge "br1_lan1" "3a:4d:a7:05:2a:46"
create_ovs_bridge "br0_lan2" "3a:4d:a7:05:2a:49"
create_ovs_bridge "br1_lan2" "3a:4d:a7:05:2a:50"


create_ovs_bridge "br0_lan3" "3a:4d:a7:05:2a:47"
create_ovs_bridge "br1_lan3" "3a:4d:a7:05:2a:67"



# sudo ovs-vsctl set bridge br0 other-config:datapath-id=209326269119040
# sudo ovs-vsctl set bridge br1 other-config:datapath-id=187971798259276

#209544804549707
#33227011233353

create_vlan "vlan11" "br0_lan1" "1" "10.1.3.1/24" "9e:c3:c6:49:0e:e8" "1"
create_vlan "vlan12" "br0_lan1" "2" "10.1.4.1/24" "16:67:1f:3f:86:a7" "5"
create_vlan "vlan13" "br0_lan1" "3" "10.1.5.1/24" "fe:46:67:35:0d:d1" "7"

echo "Connect br0_lan1 to controller 10.1.5.100:6633"
sudo ovs-vsctl set-controller br0_lan1 tcp:10.1.5.100:6633

create_vlan "vlan16" "br1_lan1" "10" "10.1.10.1/24" "8a:ae:02:40:8f:93" "40"
create_vlan "vlan17" "br1_lan1" "11" "10.1.11.1/24" "ea:6a:20:a0:96:11" "41"
create_vlan "vlan18" "br1_lan1" "12" "10.1.12.1/24" "ea:6a:20:a0:46:12" "42"

echo "Connect br1_lan1 to controller 10.1.11.100:6633"
sudo ovs-vsctl set-controller br1_lan1 tcp:10.1.11.100:6633

#LAN2
create_vlan "vlan21" "br0_lan2" "21" "10.2.3.1/24" "8a:ae:02:40:8f:96" "50"
create_vlan "vlan22" "br0_lan2" "22" "10.2.4.1/24" "ea:6a:20:a0:96:15" "51"
create_vlan "vlan23" "br0_lan2" "23" "10.2.5.1/24" "ea:6a:20:a0:96:17" "52"

echo "Connect br0_lan2 to controller 10.2.5.100:6633"
sudo ovs-vsctl set-controller br0_lan2 tcp:10.2.5.100:6633

create_vlan "vlan26" "br1_lan2" "26" "10.2.10.1/24" "8a:ae:02:40:4f:93" "56"
create_vlan "vlan27" "br1_lan2" "27" "10.2.11.1/24" "ea:6a:20:a0:26:11" "57"

echo "Connect br1_lan2 to controller 10.2.11.100:6633"
sudo ovs-vsctl set-controller br1_lan2 tcp:10.2.11.100:6633


#LAN3
create_vlan "vlan31" "br0_lan3" "31" "10.3.3.1/24" "8a:ae:02:40:3f:96" "60"
create_vlan "vlan32" "br0_lan3" "32" "10.3.4.1/24" "ea:6a:20:a0:36:15" "61"
create_vlan "vlan33" "br0_lan3" "33" "10.3.5.1/24" "ea:6a:20:a0:36:17" "62"

echo "Connect br0_lan3 to controller 10.3.5.100:6633"
sudo ovs-vsctl set-controller br0_lan3 tcp:10.3.5.100:6633

create_vlan "vlan36" "br1_lan2" "36" "10.3.10.1/24" "8a:ae:02:40:3f:93" "66"
create_vlan "vlan37" "br1_lan2" "37" "10.3.11.1/24" "ea:6a:20:a0:36:11" "67"

echo "Connect br1_lan3 to controller 10.3.11.100:6633"
sudo ovs-vsctl set-controller br1_lan3 tcp:10.3.11.100:6633


create_vlan_forward_rules "${vlans1[@]}"
create_vlan_forward_rules "${vlans2[@]}"
create_vlan_forward_rules "${vlans3[@]}"

sudo ovs-vsctl -- add-port br0_lan1 patch0 -- set interface patch0 type=patch ofport=45 options:peer=patch1 \
-- add-port br1_lan1 patch1 -- set interface patch1 type=patch ofport=46 options:peer=patch0

sudo ovs-vsctl -- add-port br0_lan2 patch2 -- set interface patch2 type=patch ofport=85 options:peer=patch3 \
-- add-port br1_lan2 patch3 -- set interface patch3 type=patch ofport=86 options:peer=patch2

sudo ovs-vsctl -- add-port br0_lan3 patch4 -- set interface patch4 type=patch ofport=87 options:peer=patch5 \
-- add-port br1_lan3 patch5 -- set interface patch5 type=patch ofport=88 options:peer=patch4

#PATCH WAN

sudo ovs-vsctl -- add-port br1_lan1 patch10 -- set interface patch10 type=patch ofport=95 options:peer=patch11 \
-- add-port br_wan patch11 -- set interface patch11 type=patch ofport=96 options:peer=patch10

sudo ovs-vsctl -- add-port br1_lan2 patch12 -- set interface patch12 type=patch ofport=97 options:peer=patch13 \
-- add-port br_wan patch13 -- set interface patch13 type=patch ofport=98 options:peer=patch12

sudo ovs-vsctl -- add-port br1_lan3 patch14 -- set interface patch14 type=patch ofport=99 options:peer=patch15 \
-- add-port br_wan patch15 -- set interface patch15 type=patch ofport=100 options:peer=patch14



sudo iptables -t nat -A POSTROUTING -o patch0 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o patch1 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o patch2 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o patch3 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o patch4 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o patch5 -j MASQUERADE

