#!/bin/sh

# check privilege
if [ "${EUID:-$(id -u)}" -ne 0 ]
then
    echo "Please run this script with root privilege."
    exit 1
fi

echo "Welcome to use multi-mc tool"
read -p "Are you sure you want to install necessary packages and start building the server? [y/n] " flag
if [ "${flag}" != "y" ] && [ "${flag}" != "Y" ]
then
    echo "Bye"
    exit 0
fi

# install necessary packages
echo "\033[36m[Install Necessary Packages]\033[m"
echo "Package update..."
apt update
echo "Install Docker..."
apt install docker.io
echo "Install HAProxy..."
apt install haproxy
echo "\033[32mDone\033[m"

