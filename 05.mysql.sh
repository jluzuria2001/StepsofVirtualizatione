#!/bin/bash

MYSQL_USER="dbuser"
MYSQL_PASS="dbpass"
MYSQL_SERVER="0.0.0.0"

echo "-- mysql - prepare install variables"
echo "mysql-server-5.5 mysql-server/root_password password $MYSQL_PASS" | sudo debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password_again password $MYSQL_PASS" | sudo debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password seen true" | sudo debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password_again seen true" | sudo debconf-set-selections

echo "-- mysql - install my libs"
sudo apt-get -y install mysql-server python-mysqldb

echo "-- my_setup - update conf"
sudo sed -i "s/bind-address.*/bind-address = $MYSQL_SERVER/" /etc/mysql/my.cnf

echo "-- mysql - restart service"
sudo service mysql restart

if ! mysql -uroot -p$MYSQL_PASS -e "select User from mysql.user;" | grep "$MYSQL_USER" &>/dev/null
then
echo "-- mysql - create db user"
    mysql -uroot -p$MYSQL_PASS -e "create user \"$MYSQL_USER\"@\"localhost\" identified by \"$MYSQL_PASS\";"
    mysql -uroot -p$MYSQL_PASS -e "create user \"$MYSQL_USER\"@\"%\" identified by \"$MYSQL_PASS\";"
fi

# nova glance cinder keystone quantum
for app in nova keystone
do
echo "-- mysql - set $app schema, user and passwd"
    mysql -uroot -p$MYSQL_PASS -e "create schema if not exists $app;"
    mysql -uroot -p$MYSQL_PASS -e "grant all privileges on $app.* to \"$MYSQL_USER\"@\"localhost\";"
    mysql -uroot -p$MYSQL_PASS -e "grant all privileges on $app.* to \"$MYSQL_USER\"@\"%\";"
done
