#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    sudo bash $0
    exit
fi

app_home="/opt/scripts/yhbp/"
echo "Installing yhbp..."
rm -r $app_home
mkdir -p $app_home
touch $app_home".yhbp"