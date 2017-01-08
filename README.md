## Docker apache2_phpcgi image

## !!! at work - not finished yet !!!!

This docker image is debian wheezy based with the apache2.2 webserver and several php fastcgi version.

PHP fastcgi versions are compiled from phpfarm.
https://sourceforge.net/projects/phpfarm/

### Features:
* standard wheezy php version 5.4.45-0+deb7u6 at port 80
* php fastcgi version 5.2.17 at port 82
* php fastcgi version 5.3.29 at port 83
* php fastcgi version 5.4.45 at port 84
* php fastcgi version 5.6.29 at port 86

### Volumes
* /var/www
* /opt/phpfarm
* /etc/apache2
* /etc/php5/cgi/5.2.17
* /etc/php5/cgi/5.3.29
* /etc/php5/cgi/5.4.45
* /etc/php5/cgi/5.6.29
* /var/log/apache2


### Run without volumes:
    docker run: -d --name ap2-fcgi -p 81:80 -p 82:82 -p 83:83 -p 84:84 pipp37/apache2_phpcgi 
  
The apache web server is available at the container host at ports 80, 82, 83, 84 and 86.

### Commands:
##### Running containers:
    docker ps
##### Attach shell to container with:
    docker exec -it ContainerID /bin/bash
