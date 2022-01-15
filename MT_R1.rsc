# jan/15/2022 06:44:14 by RouterOS 7.1.1
# software id = 
#
/interface ethernet
set [ find default-name=ether1 ] name=WAN
set [ find default-name=ether2 ] name=bound1
set [ find default-name=ether3 ] name=bound2
/interface bonding
add mode=802.3ad name=bonding1 slaves=bound1,bound2
/disk
set sata1 disabled=no
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=dhcp_pool0 ranges=10.1.1.2-10.1.1.254
/ip dhcp-server
add address-pool=dhcp_pool0 interface=ether4 name=dhcp1
/port
set 0 name=serial0
/routing table
add fib name=to_WAN_1
add fib name=to_WAN_2
/ip address
add address=10.1.1.1/24 interface=ether4 network=10.1.1.0
add address=10.3.3.1/30 interface=bonding1 network=10.3.3.0
add address=192.168.122.231/24 interface=WAN network=192.168.122.0
/ip dhcp-client
add disabled=yes interface=WAN
/ip dhcp-server network
add address=10.1.1.0/24 dns-server=1.1.1.1 gateway=10.1.1.1
/ip dns
set allow-remote-requests=yes servers=1.1.1.1,8.8.4.4
/ip firewall mangle
add action=mark-connection chain=input in-interface=WAN new-connection-mark=\
    WAN_1_conn
add action=mark-connection chain=input in-interface=bonding1 \
    new-connection-mark=WAN_2_conn
add action=mark-routing chain=output connection-mark=WAN_1_conn \
    new-routing-mark=to_WAN_1
add action=mark-routing chain=output connection-mark=WAN_2_conn \
    new-routing-mark=to_WAN_2
add action=accept chain=prerouting dst-address=192.168.122.0/24 in-interface=\
    ether4
add action=accept chain=prerouting dst-address=10.3.3.0/30 in-interface=\
    ether4
add action=mark-connection chain=prerouting dst-address-type=!local \
    in-interface=ether4 new-connection-mark=WAN_1_conn passthrough=yes \
    per-connection-classifier=both-addresses-and-ports:2/0
add action=mark-connection chain=prerouting dst-address-type=!local \
    in-interface=ether4 new-connection-mark=WAN_2_conn passthrough=yes \
    per-connection-classifier=both-addresses-and-ports:2/1
add action=mark-routing chain=prerouting connection-mark=WAN_1_conn \
    in-interface=ether4 new-routing-mark=to_WAN_1
add action=mark-routing chain=prerouting connection-mark=WAN_2_conn \
    in-interface=ether4 new-routing-mark=to_WAN_2
add action=mark-connection chain=prerouting dst-address-type=!local \
    in-interface=ether4 new-connection-mark=WAN_1_conn passthrough=yes \
    per-connection-classifier=both-addresses-and-ports:2/0
add action=mark-connection chain=prerouting dst-address-type=!local \
    in-interface=ether4 new-connection-mark=WAN_2_conn passthrough=yes \
    per-connection-classifier=both-addresses-and-ports:2/1
add action=mark-connection chain=prerouting dst-address-type=!local \
    in-interface=ether4 new-connection-mark=WAN_2_conn passthrough=yes \
    per-connection-classifier=both-addresses-and-ports:2/2
/ip firewall nat
add action=masquerade chain=srcnat out-interface=WAN
add action=masquerade chain=srcnat out-interface=bonding1
/ip route
add check-gateway=ping disabled=no distance=1 dst-address=0.0.0.0/0 gateway=\
    192.168.122.1 pref-src="" routing-table=to_WAN_1 suppress-hw-offload=no
add check-gateway=ping disabled=no distance=2 dst-address=0.0.0.0/0 gateway=\
    10.3.3.2 routing-table=to_WAN_2 suppress-hw-offload=no
/ip service
set telnet disabled=yes
/system identity
set name=MikroTik_R1

-----------------------------43180658915113744011995126528--