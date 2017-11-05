# Debian Wheezy
# Version 0.9 31.12.2016
FROM debian:7.11
MAINTAINER arminpipp <armin@pipp.at>

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# change apt sources
ADD sources.list  /etc/apt/sources.list

RUN    apt-get update \
   &&  apt-get -y --force-yes install wget git git-core nano make gcc g++ apt-transport-https  sudo \ 
   &&  apt-get -y --force-yes install mc vim htop  libssl-dev telnet-ssl  dialog curl  \
   &&  apt-get install -y --force-yes  lemon build-essential \
   &&  apt-get clean

# php compilation
RUN    apt-get install -y --force-yes   libxml2 libxml2-dev libssl-dev libicu48 \
   &&  apt-get install -y --force-yes   libcurl4-gnutls-dev libjpeg-dev libpng12-dev \
   &&  apt-get install -y --force-yes   libcurl4-openssl-dev pkg-config libmysqlclient-dev \
   &&  apt-get install -y --force-yes   libxpm-dev libmcrypt-dev libxpm4 libmcrypt4 \
   &&  apt-get install -y --force-yes   libgd2-xpm-dev \
   &&  apt-get install -y --force-yes   libfreetype6-dev libfreetype6 libt1-5 libt1-dev \
   &&  apt-get clean

# apache2
RUN    apt-get install -y --force-yes   apache2 php5 php-pear php5-mcrypt php5-mysql ttf-dejavu-core lynx \
   &&  apt-get install -y --force-yes   libgd2-xpm  mysql-client php5-gd libjpeg8 libjpeg8-dev  \
   &&  apt-get install -y --force-yes   apache2-mpm-worker apache2-suexec libapache2-mod-fastcgi libapache2-mod-fcgid php5-cgi \
   &&  apt-get install -y --force-yes   libapache2-mod-php5 netcat rsyslog \
   &&  apt-get clean
 
# do not install php5-fpm

####
# symlinks not needed - changed compile custom-options-x.x.x
# make some symlinks for build php 5.2 on x64 systems
#RUN     ln -s /usr/lib/x86_64-linux-gnu/libjpeg.a /usr/lib/libjpeg.a  \
#     && ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib/libjpeg.so \
#     && ln -s /usr/lib/x86_64-linux-gnu/libpng.a /usr/lib/libpng.a \
#     && ln -s /usr/lib/x86_64-linux-gnu/libpng.so /usr/lib/libpng.so \
#     && ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient.so /usr/lib/libmysqlclient.so \     
#     && ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient.a /usr/lib/libmysqlclient.a 

#  ln -s /usr/lib/x86_64-linux-gnu/libjpeg.a /usr/lib/libjpeg.a && \
#  ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib/libjpeg.so && \
#  ln -s /usr/lib/x86_64-linux-gnu/libpng.a /usr/lib/libpng.a && \
#  ln -s /usr/lib/x86_64-linux-gnu/libpng.so /usr/lib/libpng.so  && \
#  ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient.so /usr/lib/libmysqlclient.so && \
#  ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient.a /usr/lib/libmysqlclient.a


# phpfarm
WORKDIR /opt
RUN git clone https://github.com/cweiske/phpfarm

##########################################
# php 5.2.17
#
# copy custom compiler options
# custom-options-5.2.17.sh
# compile php 
# set environment var
ENV PHP52 5.2.17
ADD      custom-options-${PHP52}.sh /opt/phpfarm/src/
WORKDIR  /opt/phpfarm/src
RUN      /opt/phpfarm/src/compile.sh ${PHP52}  \
       && rm -r /opt/phpfarm/src/php-${PHP52}
###


##########################################
# php 5.3.29
#
# copy custom compiler options
# custom-options-5.3.29.sh
# compile php
# set environment var
ENV PHP53 5.3.29
ADD      custom-options-${PHP53}.sh /opt/phpfarm/src/
WORKDIR  /opt/phpfarm/src
RUN      /opt/phpfarm/src/compile.sh ${PHP53} \
       && rm -r /opt/phpfarm/src/php-${PHP53}
###


##########################################
# php 5.4.45
#
# copy custom compiler options
# custom-options-5.4.45.sh
# compile php
# set environment var
ENV PHP54 5.4.45
ADD       custom-options-${PHP54}.sh /opt/phpfarm/src/
WORKDIR   /opt/phpfarm/src
RUN       /opt/phpfarm/src/compile.sh ${PHP54} \
	   &&  rm -r /opt/phpfarm/src/php-${PHP54}
###


##########################################
# php 5.6.29
#
# copy custom compiler options
# custom-options-5.6.29.sh
# compile php
# set environment var
ENV PHP56 5.6.29
ADD      custom-options-${PHP56}.sh /opt/phpfarm/src/
WORKDIR  /opt/phpfarm/src
RUN      /opt/phpfarm/src/compile.sh ${PHP56} \
	   && rm -r /opt/phpfarm/src/php-${PHP56}
###


### apache :80
# config  apache files for standard instance
RUN mv /var/www/index.html  /var/www/index1.html
# enable fastcgi and other modules
RUN /usr/sbin/a2enmod actions fcgid fastcgi suexec rewrite setenvif
RUN mkdir -p /var/www/cgi-bin

WORKDIR /
# add apachecfg tools
ADD cfg.tgz /

# config apache for php 5.2.17 on port 82
RUN /_cfg/apachecfg.sh ${PHP52} 82

# config apache for php 5.3.29 on port 83
RUN /_cfg/apachecfg.sh ${PHP53} 83

# config apache for php 5.4.45 on port 84
RUN /_cfg/apachecfg.sh ${PHP54} 84

# config apache for php 5.6.29 on port 86
RUN /_cfg/apachecfg.sh ${PHP56} 86

# create tgz files from volumes
RUN    /_cfg/volumedata.sh create /var/www  \
    && /_cfg/volumedata.sh create /var/log/apache2  \
    && /_cfg/volumedata.sh create /etc/apache2  \
    && /_cfg/volumedata.sh create /etc/php5/cgi/${PHP52} \
    && /_cfg/volumedata.sh create /etc/php5/cgi/${PHP53} \
    && /_cfg/volumedata.sh create /etc/php5/cgi/${PHP54} \
    && /_cfg/volumedata.sh create /etc/php5/cgi/${PHP56} 

ADD myinit.sh /
RUN chmod +x /myinit.sh

EXPOSE 80 82 83 84 86

VOLUME /var/www  /etc/apache2  /var/log/apache2
VOLUME /etc/php5/cgi/${PHP53} /etc/php5/cgi/${PHP54} /etc/php5/cgi/${PHP56} 

# add healthcehck for apache (docker 1.12)
# HEALTHCHECK --interval=5m --timeout=3s  CMD curl -f http://localhost/ || exit 1

#install php composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer


# start initscript and apache/
# CMD ["apachectl", "-D", "FOREGROUND"]
CMD ["/myinit.sh"]

# End Dockerfile
