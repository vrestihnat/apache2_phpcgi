## Docker apache2_phpcgi image

This docker image is debian wheezy based with the apache2.2 webserver and several php fastcgi versions.

PHP fastcgi versions are compiled from phpfarm.
https://sourceforge.net/projects/phpfarm/

### Features:
* standard wheezy php version 5.4.45-0+deb7u6 at port 80
* php fastcgi version 5.2.17 at port 82
* php fastcgi version 5.3.29 at port 83
* php fastcgi version 5.4.45 at port 84
* php fastcgi version 5.6.29 at port 86
* initial extract of volumedata (do not overwrites existing files and runs only at first startup)

### Volumes
* /var/www
* /etc/apache2
* /etc/php5/cgi/5.2.17
* /etc/php5/cgi/5.3.29
* /etc/php5/cgi/5.4.45
* /etc/php5/cgi/5.6.29
* /var/log/apache2

### Run without host volumes:
    docker run -d --name ap2-fcgi -p 81:80 -p 82:82 -p 83:83 -p 84:84 pipp37/apache2_phpcgi 
  
The apache web server is then available at the container host at ports 81, 82, 83, 84 and 86.

### Run with all volumes:
    docker run -d --name ap2-fcgi -p 81:80 -p 82:82 -p 83:83 -p 84:84 \
    -v /var/apache2-phpcgi/www/:/var/www/   \
    -v /var/apache2-phpcgi/apache2/:/etc/apache2/  \
    -v /var/apache2-phpcgi/logs/:/var/log/apache2/ \
    -v /var/apache2-phpcgi/php5.2.17/:/etc/php5/cgi/5.2.17 \
    -v /var/apache2-phpcgi/php5.3.29/:/etc/php5/cgi/5.3.29 \
    -v /var/apache2-phpcgi/php5.4.45/:/etc/php5/cgi/5.4.45 \
    -v /var/apache2-phpcgi/php5.6.29/:/etc/php5/cgi/5.6.29  pipp37/apache2_phpcgi
  
The apache web server is available at the container host at ports 81, 82, 83, 84 and 86 with all volumes in /var/apache2-phpcgi.

### Commands:
##### Running containers:
    docker ps
##### Attach shell to container with:
    docker exec -it ContainerID /bin/bash
    
### Docker compose
Create a file `docker-compose.yml`

    version: '2'
    services:
      apache2:
        image: pipp37/apache2_phpcgi
        ports:
            - "81:80"
            - "82:82"
            - "83:83"
            - "84:84"
            - "86:86"
        volumes:
            - ./logs:/var/log/apache2
            - ./www:/var/www
            - ./apache2:/etc/apache2
            - ./php5.2.17:/etc/php5/cgi/5.2.17
            - ./php5.3.29:/etc/php5/cgi/5.3.29
            - ./php5.4.45:/etc/php5/cgi/5.4.45
            - ./php5.6.29:/etc/php5/cgi/5.6.29

Start with: `docker-compose up &`

Stop with: `docker compose down`
