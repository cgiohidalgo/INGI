#!/bin/bash

#this script sets up all configuration files for lighttpd along with INGInious  
mkdir -p /var/www/INGInious/
mkdir -p /var/www/INGInious/tasks
mkdir -p /var/www/INGInious/backup
cp configutation.yaml /var/www/INGInious/
cp lighttpd.conf /etc/lighttpd/
cp modules.conf /etc/lighttpd/
cp fastcgi.conf /etc/lighttpd/conf.d/