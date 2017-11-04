#!/bin/bash
# creating data for volumes from initial tar files 
/_cfg/volumedata.sh write /var/www
/_cfg/volumedata.sh write /var/log/apache2
/_cfg/volumedata.sh write /etc/apache2
/_cfg/volumedata.sh write /etc/php5/cgi/$PHP52
/_cfg/volumedata.sh write /etc/php5/cgi/$PHP53
/_cfg/volumedata.sh write /etc/php5/cgi/$PHP54
/_cfg/volumedata.sh write /etc/php5/cgi/$PHP56


echo " 
local6.info @172.16.17.254:514

local1.crit   /var/log/apache.crit

local6.info /var/log/apache2/access.log

local6.info /var/log/apache2/error.log


$ModLoad imuxsock

$ModLoad imklog

# Provides UDP forwarding. The IP is the server's IP address
*.* @172.16.17.254:514

" >> /etc/rsyslog.conf

# start apache
exec apachectl -D  FOREGROUND

