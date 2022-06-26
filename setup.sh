#!/bin/sh

printTitle() {
    echo "\033[36m[$1]\033[m"
}

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

# check firewall
printTitle "Check Firewall"
if [ -z "$(ufw status | grep active)" ]
then
    # inactive or disabled
    echo "UFW is off."
    firewall=0
else
    echo "UFW is on."
    firewall=1
fi

# install necessary packages
printTitle "Install Necessary Packages"
echo "Package update..."
apt update
echo "Install Docker..."
apt install docker.io
echo "\033[32mDone\033[m"

