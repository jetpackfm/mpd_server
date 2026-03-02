# feb/28/2026 14:43:14 by RouterOS 6.49.19
# software id = 0DBN-ZBZR
#
# model = RBD52G-5HacD2HnD
# serial number = BEEB0A1F7F8F
/interface bridge
add arp=proxy-arp dhcp-snooping=yes name=bridge vlan-filtering=yes
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n country=russia3 disabled=no \
    mode=ap-bridge ssid=MGTS_GPON_3707
set [ find default-name=wlan2 ] band=5ghz-n/ac country=russia3 disabled=no \
    mode=ap-bridge ssid=MGTS_GPON5_3707
/interface vlan
add interface=bridge name=vlan-server vlan-id=10
/interface wireless security-profiles
set [ find default=yes ] authentication-types=wpa2-psk mode=dynamic-keys \
    supplicant-identity=MikroTik wpa2-pre-shared-key=your_password
/ip pool
add name=dhcp_pool1 ranges=10.10.10.2-10.10.10.254
add name=dhcp_pool_main ranges=192.168.1.100-192.168.1.200
/ip dhcp-server
add address-pool=dhcp_pool1 disabled=no interface=vlan-server lease-time=1d \
    name=dhcp1
/interface bridge port
add bridge=bridge interface=ether1 trusted=yes
add bridge=bridge interface=ether2
add bridge=bridge interface=ether3
add bridge=bridge interface=ether4
add bridge=bridge interface=ether5 pvid=10
add bridge=bridge interface=wlan1
add bridge=bridge interface=wlan2
/ip neighbor discovery-settings
set discover-interface-list=!dynamic
/interface bridge vlan
add bridge=bridge tagged=bridge untagged=ether5 vlan-ids=10
/ip address
add address=10.10.10.1/24 interface=vlan-server network=10.10.10.0
/ip arp
add address=10.10.10.254 interface=vlan-server mac-address=0C:EF:15:5F:12:9E
/ip dhcp-client
add disabled=no interface=bridge
/ip dhcp-server network
add address=10.10.10.0/24 dns-server=8.8.8.8,8.8.4.4 gateway=10.10.10.1
add address=192.168.1.0/24 dns-server=8.8.8.8,8.8.4.4 gateway=192.168.1.254
/ip firewall filter
add action=accept chain=forward comment="allow established/related" \
    connection-state=established,related
add action=accept chain=forward comment="allow SSH from PC" dst-address=\
    10.10.10.254 dst-port=22 protocol=tcp src-address=192.168.1.69
add action=accept chain=forward comment="allow MPD from PC" dst-address=\
    10.10.10.254 dst-port=6600 protocol=tcp src-address=192.168.1.69
add action=drop chain=forward comment=\
    "block all other traffic from main net to VLAN 10" dst-address=\
    10.10.10.0/24 src-address=192.168.1.0/24
/ip firewall nat
add action=masquerade chain=srcnat out-interface=bridge src-address=\
    10.10.10.0/24
/system clock
set time-zone-name=Europe/Moscow
