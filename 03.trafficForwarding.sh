#Install VLAN, Bridge-Utils, and setup IP Forwarding
#---------------------------------------------------

# Install the VLAN and Bridge-Utils services:
	apt-get install vlan bridge-utils

# Enable IP_Forwarding
#	by uncommenting net.ipv4.ip_forward=1 in /etc/sysctl.conf:
	vi /etc/sysctl.conf
	service procps start

# Now, run systcl with the updated configuration:
	sysctl -p
