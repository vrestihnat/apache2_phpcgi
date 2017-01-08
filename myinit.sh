#!/bin/bash
# creating data for volumes from initial tar files 
/_cfg/volumedata.sh write /var/www
/_cfg/volumedata.sh write /var/log/apache2
/_cfg/volumedata.sh write /etc/apache2
/_cfg/volumedata.sh write /opt/phpfarm
/_cfg/volumedata.sh write /etc/php5/cgi/$PHP52
/_cfg/volumedata.sh write /etc/php5/cgi/$PHP53
/_cfg/volumedata.sh write /etc/php5/cgi/$PHP54
/_cfg/volumedata.sh write /etc/php5/cgi/$PHP56

# start apache
exec apachectl -D  FOREGROUND

