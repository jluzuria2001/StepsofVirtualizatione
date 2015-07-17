#!/bin/bash

if ! sudo grep "eth1" /etc/network/interfaces &>/dev/null
then
echo "network - update interfaces config"
    sudo tee -a /etc/network/interfaces >/dev/null <<EOF

# Public Interface
auto eth1
iface eth1 inet static
address 172.16.0.1
netmask 255.255.0.0
network 172.16.0.0
broadcast 172.16.255.255

# Private Interface
auto eth2
iface eth2 inet manual
up ifconfig eth2 up
EOF

    echo "update_network - start interfaces"
    sudo ifup eth1
    sudo ifup eth2
fi

if [ -f /etc/init.d/nova-network ];
then
echo "network - restart nova-network service"
    sudo restart nova-network
fi
