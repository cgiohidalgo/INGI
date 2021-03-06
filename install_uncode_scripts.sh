#!/bin/bash

# Installs the uncode_scripts i.e. copies the scripts to the folder /usr/bin

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

chmod +x ./uncode_scripts/uncode*
cp ./uncode_scripts/uncode* /usr/bin

echo "uncode scripts installation successful"