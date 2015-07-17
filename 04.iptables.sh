# 4. Enable routing in the host: uncomment 
net.ipv4.ip_forward=1 
# in [ /etc/sysctl.conf ] 
(/etc/ufw/sysctl.conf if using ufw), 

# or temporarily with 
echo 1 >/proc/sys/net/ipv4/ip_forward.

# 5. Change virtlib forward from nat to route and adjust dhcp range to exclude the address used for guest 
# (optionally, add host entry for it): 
# virsh net-edit default and change the xml to something like this:

<network>
	<name>default</name>
  	<uuid>12345678-1234-1234-1234-123456789abc</uuid>
	<forward mode='route'/>
	<bridge name='virbr0' stp='on' delay='0' />
	<ip address='192.168.122.1' netmask='255.255.255.0'>
		<dhcp>
			<range start='192.168.122.100' end='192.168.122.254' />
			<host mac"=00:11:22:33:44:55" name="guest.example.com" ip="192.168.122.99" />
		</dhcp>
	</ip>
</network>



# 6. Direct traffic from external interface to internal and back:

sudo iptables -t nat -A POSTROUTING -s 10.2.0.1 -j SNAT --to-source 192.168.1.100
sudo iptables -t nat -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

sudo sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'


#---------------------------
#	comprobar:
#---------------------------
sudo iptables -n -t nat -L


#----------DELETE ALL OF IPTABLES----------
# Delete and flush. Default table is "filter". Others like "nat" must be explicitly stated.
iptables --flush

# Flush all the rules in filter and nat tables
iptables --table nat --flush
iptables --delete-chain

# Delete all chains that are not in default filter and nat table
iptables --table nat --delete-chain

#********************************************
sudo iptables --flush
sudo iptables --table nat --flush
sudo iptables --delete-chain
sudo iptables --table nat --delete-chain
sudo service ufw restart
#********************************************

#----RESTART THE SERVICE-----------

#The Universal FireWall or ufw is the firewall using iptables that comes by default on Ubuntu. 
#So if you wanted to start or stop the ufw firewall service, 
#you'd have to do something like this

	
#ACTION		COMMAND				RESULT
#To stop	
sudo service ufw stop		
#ufw stop/waiting

#To start	
sudo service ufw start		
#ufw start/running


# * others ports to a web service:

iptables -t nat -I PREROUTING -p tcp --dport 81 -j DNAT --to 10.2.0.1
iptables -I FORWARD -p tcp -d 10.2.0.1 --dport 80 -j ACCEPT

iptables -t nat -I PREROUTING -p tcp --dport 8080 -j DNAT --to 10.2.0.1
iptables -I FORWARD -p tcp -d 10.2.0.1 --dport 8080 -j ACCEPT



# REFERENCES:
# [1] https://help.ubuntu.com/community/KVM/Networking
