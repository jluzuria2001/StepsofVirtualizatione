#Install and configure the NTP service
#-------------------------------------

#Install the NTP service:
	sudo apt-get install ntp

#Configure the NTP server to synchronize between your compute node(s) and the controller node:

	sed -i ‘s/server ntp.ubuntu.com/server ntp.ubuntu.com\nserver 127.127.1.0\nfudge 127.127.1.0 stratum 10/g’ /etc/ntp.conf
	service ntp restart
