from network import Host, Honeypot, Attacker, Subnet, Network, Gateway

#------- NETWORK TOPOLPOGY LAN1 -------------------------------------------------------------- #    
# Nodes
#Subnet 1
host = Host('host', '10.1.3.10', '08:00:27:b6:d0:66', 15, '255.255.255.0')
service = Host('service', '10.1.3.11', '08:00:27:6d:ec:62', 3, '255.255.255.0')
ssh_service = Host('ssh_service', '10.1.3.13', '08:00:27:b6:d0:69', 16, '255.255.255.0')
heralding = Honeypot('heralding', '10.1.3.12', '08:00:27:6c:0a:bf', 4, '255.255.255.0')

#Subnet 2
cowrie = Honeypot('cowrie', '10.1.4.10', '08:00:27:b7:0e:58', 6, '255.255.255.0')
heralding1 = Honeypot('heralding1', '10.1.4.11', '08:00:27:6d:f9:98', 13, '255.255.255.0')

heralding_host = Honeypot('heralding_host', '10.1.4.17', '08:00:27:6d:ec:c4', 25, '255.255.255.0')

elk_if1 = Host('ELK_IF1', '10.1.5.10', '08:00:27:7d:b7:b8', 8, '255.255.255.0')
elk_if2 = Host('ELK_IF2', '10.1.11.10', '08:00:27:f5:6b:90', 13, '255.255.255.0')

dmz_heralding = Honeypot('dmz_heralding', '10.1.10.10', '08:00:27:2c:30:92', 2, '255.255.255.0')
dmz_service = Host('dmz_service', '10.1.10.11', '08:00:27:b6:d0:67', 22, '255.255.255.0')
dmz_service1 = Host('dmz_service1', '10.1.10.14', '08:00:27:6d:ec:74', 21, '255.255.255.0')
dmz_cowrie = Honeypot('dmz_cowrie', '10.1.10.13', '08:00:27:b7:0e:59', 20, '255.255.255.0')
dmz_host = Host('dmz_host', '10.1.10.12', '08:00:27:b6:d0:68', 23, '255.255.255.0')


# Subnets
# ovs1
subnet1 = Subnet('S1', '10.1.3.0', '255.255.255.0')
subnet2 = Subnet('S2', '10.1.4.0', '255.255.255.0')
subnet3 = Subnet('S3', '10.1.5.0', '255.255.255.0')
#ovs2
subnet4 = Subnet('S4', '10.1.10.0', '255.255.255.0')
subnet5 = Subnet('S5', '10.1.11.0', '255.255.255.0')

# Gateways
# ovs1
gw1 = Gateway('gw1', '10.1.3.1', '9e:c3:c6:49:0e:e8', 1, '255.255.255.0')
gw2 = Gateway('gw2', '10.1.4.1', '16:67:1f:3f:86:a7', 5, '255.255.255.0')
gw3 = Gateway('gw3', '10.1.5.1', 'fe:46:67:35:0d:d1', 7, '255.255.255.0')
# ovs2
gw10 = Gateway('gw10', '10.1.10.1', '8a:ae:02:40:8f:83', 10, '255.255.255.0')
gw11 = Gateway('gw11', '10.1.11.1', 'ea:6a:20:a0:96:10', 11, '255.255.255.0')

# Network
network1 = Network('Net1')
network2 = Network('Net2')

# Add nodes to subnets
# ovs1
subnet1.add_node(host, host.get_ovs_port())
subnet1.add_node(heralding, heralding.get_ovs_port())
subnet1.add_node(service, service.get_ovs_port())
subnet1.add_node(ssh_service, ssh_service.get_ovs_port())
subnet1.add_node(gw1, gw1.get_ovs_port())

subnet2.add_node(cowrie, cowrie.get_ovs_port())
subnet2.add_node(heralding1, heralding1.get_ovs_port())
subnet2.add_node(gw2, gw2.get_ovs_port())

subnet3.add_node(elk_if1, elk_if1.get_ovs_port())
subnet3.add_node(gw3, gw3.get_ovs_port())

#ovs2
subnet4.add_node(dmz_service, dmz_service.get_ovs_port())
subnet4.add_node(dmz_heralding, dmz_heralding.get_ovs_port())
subnet4.add_node(dmz_host, dmz_host.get_ovs_port())
subnet4.add_node(dmz_cowrie, dmz_cowrie.get_ovs_port())
subnet4.add_node(dmz_service1, dmz_service1.get_ovs_port())
subnet4.add_node(gw10, gw10.get_ovs_port())

subnet5.add_node(elk_if2, elk_if2.get_ovs_port())
subnet5.add_node(gw11, gw11.get_ovs_port())


# Add subnets to network
network1.add_subnet(subnet1)
network1.add_subnet(subnet2)
network1.add_subnet(subnet3)

network2.add_subnet(subnet4)
network2.add_subnet(subnet5)

ports = [5432, 143, 5900, 3306]

br0_dpid = 64105189026373
br1_dpid = 64105189026374
