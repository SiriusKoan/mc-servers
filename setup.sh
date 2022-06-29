#!/usr/bin/bash

printTitle() {
    echo -e "\033[36m[$1]\033[m"
}

printError() {
    echo -e "\033[31m$1\033[m"
}

printWarning() {
    echo -e "\033[33m$1\033[m"
}

printOK() {
    echo -e "\033[32m$1\033[m"
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
if [ $test ]
then
    echo "Testing, skipped."
else
    echo "Package update..."
    apt update
    echo "Install Docker..."
    apt install docker.io
    echo "Install wget..."
    apt install wget
fi

# Check configs
printTitle "Check configs"
files=($(ls config | grep '\.conf$'))
count=$(ls config | grep '\.conf$' | wc -l)
servers=""
echo "$count config files found."

# generate docker-compose.yaml and download server.jar
printTitle "Generate docker-compose.yaml and download server.jar"
> src/web/backend/rcon.txt
for f in "${files[@]}"
do
    # setup docker
    ver=$(cat "config/$f" | grep version | awk -F= '{print $2; exit;}')
    download_link=$(cat versions.txt | grep "$ver " | awk '{print $2}')
    server_name=${f%.*}
    port=$(cat "config/$f" | grep port | awk -F= '{print $2; exit;}')
    server=$(cat src/docker/docker-compose-template.yaml | sed -e "s/%%SERVERNAME%%/$server_name/" -e "s/%%PORT%%/$port/" -e "s/%%RCONPORT%%/$(expr $port + 1000)/")
    servers+="\n$server"
    # setup basic file
    mkdir -p data/${server_name}
    wget ${download_link} -O "./data/${server_name}/server.jar"
    echo "${server_name}:$(expr $port + 1000)" >> src/web/backend/rcon.txt
    # check firewall
    if [ $firewall ]
    then
        echo "Firewall is enabled, allow traffic to $port"
        ufw allow to any port $port
    fi
done
echo "version: \"2\"" > docker-compose.yaml
echo "services:" >> docker-compose.yaml
echo -e "$servers" >> docker-compose.yaml
printOK "Done."

# generate server files by running docker-compose
printTitle "Generate necessary server files"
docker-compose up -d
printOK "Done"

# sign eula
printTitle "Sign EULA"
for f in "${files[@]}"
do
    sed -i "s/false/true/" data/${f%.*}/eula.txt
done
printOK "Done"

# write settings
printTitle "Write settings to servers"
for f in "${files[@]}"
do
    conf=$(cat config/$f | grep -v version | grep -v port)
    echo "$conf" >> data/${f%.*}/server.properties
    # enable rcon
    echo "rcon-enable=true" >> data/${f%.*}/server.properties
    echo "rcon-password=123456" >> data/${f%.*}/server.properties
done
printOK "Done"

