#!/bin/bash
##############################################################################
# cfg script for apache2 
# (c) armin@pipp.at 12/2016
#
# usage:   ./apachecfg.sh <phpversion> <port>
# EXAMPLE: apchecfg 5.2.17 82
#
############################################

if [ -z $2 ]; then
    echo "Error: Missing version or Port  as parameter! IE: 5.2.17 82 " 
    exit
fi

# debug 
# echo "The script you are running has basename `basename $0`, dirname `dirname $0`"
# echo "The present working directory is `pwd`"

DIR=`dirname $0`
echo CFGdir=$DIR

AP2PORT=/etc/apache2/ports.conf

AP2SITEDIR=/etc/apache2/sites-available
AP2SITEMASTER=cgi-master.conf

AP2PHPINI=/etc/php5/cgi
AP2PHPINIMASTER=php.ini
    
AP2PHPCGI=/var/www/cgi-bin
AP2PHPCGIMASTER=php-cgi-master

AP2WWW=/var/www
AP2WWWFILE1=info.html
AP2WWWFILE2=phpinfo.php
AP2WWWFILE3=phplink.html
AP2WWWFILE4=gdtest.php

echo "Apache CFG with PHP $1 on Port $2"

##################################################
# add Listen

LISTEN="Listen $2"
echo "Edit $LISTEN in $AP2PORT"

#echo " grep -q "$LISTEN" "$AP2PORT" || echo "$LISTEN" >> "$AP2PORT""
grep -q "$LISTEN" "$AP2PORT" || echo "$LISTEN" >> "$AP2PORT"

# cat $AP2PORT


##################################################
# add sites-available
DEST=$AP2SITEDIR/cgi-$1.conf
echo sites-available 
echo " Destfile=$DEST from $AP2SITEMASTER"
cp  $DIR/$AP2SITEMASTER  $DEST

# change  files
sed -i s/\{PHP_PORT\}/$2/g $DEST
sed -i s/\{PHP\}/$1/g      $DEST

# apache enable
 a2ensite cgi-$1.conf

##################################################
# php.ini
DEST=$AP2PHPINI/$1
echo "$AP2PHPINIMASTER config in $AP2PHPINI/$1"
mkdir -p $AP2PHPINI/$1
cp $DIR/$AP2PHPINIMASTER $AP2PHPINI/$1


##################################################
# cgi-bin
DEST=$AP2PHPCGI/php-cgi-$1
echo "$AP2PHPCGIMASTER cgi in $DEST"

cp  $DIR/$AP2PHPCGIMASTER  $DEST
# change  files
sed -i s/\{PHP\}/$1/g      $DEST
chmod +x $DEST
chown www-data:www-data $DEST


##################################################
# var/www site
DEST=$AP2WWW/php-$1
echo "website data in $DEST"
mkdir -p $DEST
cp $DIR/$AP2WWWFILE1 $DEST/info-php-$1.html
cp $DIR/$AP2WWWFILE2 $DEST
cp $DIR/$AP2WWWFILE2 $AP2WWW
cp $DIR/$AP2WWWFILE3 $AP2WWW/phplink-$1.html

cp $DIR/$AP2WWWFILE4 $DEST
cp $DIR/$AP2WWWFILE4 $AP2WWW

chown    www-data:www-data $AP2WWW/*
chown -R www-data:www-data $DEST

sed -i s/\{PHP\}/$1/g      $DEST/info-php-$1.html
sed -i s/\{PHP_PORT\}/$2/g $DEST/info-php-$1.html

sed -i s/\{PHP\}/$1/g      $AP2WWW/phplink-$1.html
sed -i s/\{PHP_PORT\}/$2/g $AP2WWW/phplink-$1.html

