#__author__ = "biuro@tmask.pl"
#__copyright__ = "Copyright (C) 2021 TMask.pl"
#__license__ = "MIT License"
#__version__ = "1.0"

/ip firewall mangle

add chain=input in-interface=WAN action=mark-connection new-connection-mark=WAN_1_conn
add chain=input in-interface=bonding1 action=mark-connection new-connection-mark=WAN_2_conn

/routing/table/ add name=to_WAN_1 fib
/routing/table/ add name=to_WAN_2 fib

add chain=output connection-mark=WAN_1_conn action=mark-routing new-routing-mark=to_WAN_1
add chain=output connection-mark=WAN_2_conn action=mark-routing new-routing-mark=to_WAN_2

add chain=prerouting dst-address=192.168.122.0/24 action=accept in-interface=ether4
add chain=prerouting dst-address=10.3.3.0/30 action=accept in-interface=ether4




add chain=prerouting dst-address-type=!local in-interface=ether4 per-connection-classifier=both-addresses-and-ports:2/0 action=mark-connection new-connection-mark=WAN_1_conn passthrough=yes
add chain=prerouting dst-address-type=!local in-interface=ether4 per-connection-classifier=both-addresses-and-ports:2/1 action=mark-connection new-connection-mark=WAN_2_conn passthrough=yes

add chain=prerouting connection-mark=WAN_1_conn in-interface=ether4 action=mark-routing new-routing-mark=to_WAN_1
add chain=prerouting connection-mark=WAN_2_conn in-interface=ether4 action=mark-routing new-routing-mark=to_WAN_2


/ip route

add dst-address=0.0.0.0/0 gateway=192.168.122.1 routing-table=to_WAN_1 check-gateway=ping
add dst-address=0.0.0.0/0 gateway=10.3.3.1 routing-table=to_WAN_2 check-gateway=ping

add dst-address=0.0.0.0/0 gateway=192.168.122.1 distance=1 check-gateway=ping
add dst-address=0.0.0.0/0 gateway=10.3.3.1 distance=2 check-gateway=ping

Step 5: Create NAT Policy

/ip firewall nat

add chain=srcnat out-interface=WAN action=masquerade
add chain=srcnat out-interface=bonding1 action=masquerade


/ip firewall mangle

add chain=prerouting dst-address-type=!local in-interface=ether4 per-connection-classifier=both-addresses-and-ports:2/0 action=mark-connection new-connection-mark=WAN_1_conn passthrough=yes
add chain=prerouting dst-address-type=!local in-interface=ether4 per-connection-classifier=both-addresses-and-ports:2/1 action=mark-connection new-connection-mark=WAN_2_conn passthrough=yes
add chain=prerouting dst-address-type=!local in-interface=ether4 per-connection-classifier=both-addresses-and-ports:2/2 action=mark-connection new-connection-mark=WAN_2_conn passthrough=yes

