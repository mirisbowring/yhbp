#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    sudo bash $0
    exit
fi

verify_distribution(){
    if [ -f /etc/os-release ]; then
        # freedesktop.org and systemd
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        # linuxbase.org
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    elif [ -f /etc/lsb-release ]; then
        # For some versions of Debian/Ubuntu without lsb_release command
        . /etc/lsb-release
        OS=$DISTRIB_ID
        VER=$DISTRIB_RELEASE
    elif [ -f /etc/debian_version ]; then
        # Older Debian/Ubuntu/etc.
        OS=Debian
        VER=$(cat /etc/debian_version)
    else
        echo "Could not verify distribution or distribution is not supported."
    fi
}

install_ubuntu(){
    app_home="/opt/scripts/yhbp/"
    echo "Installing yhbp..."
    sudo service yhbp stop
    rm -r $app_home
    rm /etc/init.d/yhbp
    git clone https://gitlab.zeus-coding.de/arlindne/yhbp.git
    cd yhbp
    mv service/yhbp /etc/init.d/
    chmod +x /etc/init.d/yhbp
    mkdir -p $app_home
    touch $app_home".yhbp"
    mv ubuntu/yhbp.sh $app_home

    sudo update-rc.d yhbp defaults
    sudo service yhbp restart
    cd ..
    rm -r yhbp
    shred -u $0
}

verify_distribution