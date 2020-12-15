# Internal subnet 
LAN_NW=192.168.144.0/24

# DMZ subnet
#DMZ_NW=99.27.159.0/29
DMZ_NW=172.16.2.0/29

LAN_IFACE=enp0s20u3
DMZ_IFACE=enp0s20u4
WAN_IFACE=eno1 

LAN_IP=192.168.144.100
DMZ_IP=172.16.2.1
WAN_IP=99.27.159.146

# The IP address of a server within the DMZ
SERVICE=172.16.2.100