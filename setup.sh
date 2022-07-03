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

# detect OS
# the snippet is from https://github.com/Nyr/openvpn-install/blob/master/openvpn-install.sh
printTitle "Detect OS"
if [ "$(grep 'ubuntu' /etc/os-release)" ]
then
    os="ubuntu"
elif [ -e /etc/debian_version ]
then
    os="debian"
elif [ -e /etc/almalinux-release ] || [ -e /etc/rocky-release ] || [ -e /etc/centos-release ]
then
    os="centos"
else
    printError "Your OS is not supported."
    exit 2
fi
echo "OS is $os"

echo "Welcome to use multi-mc tool"
read -p "Are you sure you want to install necessary packages and start building the server? [y/n] " flag
if [ "${flag}" != "y" ] && [ "${flag}" != "Y" ]
then
    echo "Bye"
    exit 0
fi

# check firewall
printTitle "Check Firewall"
if [ $os = "centos" ]
then
    if [ -z "$(firewall-cmd --state | grep 'not running')" ]
    then
        echo "Firewalld is on"
        firewall=1
    else
        echo "Firewalld is off"
        firewall=0
    fi
else
    if [ -z "$(ufw status | grep active)" ]
    then
        # inactive or disabled
        echo "UFW is off."
        firewall=0
    else
        echo "UFW is on."
        firewall=1
    fi
fi

# install necessary packages
printTitle "Install Necessary Packages"
if [ $install -eq 0 ]
then
    echo "Skip package installation by user."
else
    if [ $os = "centos" ]
    then
        echo "Package update..."
        dnf update -y
        echo "Install Docker..."
        dnf install -y yum-utils
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
        curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
        echo "Install wget..."
        dnf install -y wget
    else
        echo "Package update..."
        apt update -y
        echo "Install Docker..."
        apt install -y docker.io
        echo "Install wget..."
        apt install -y wget
    fi
fi

# Check configs
printTitle "Check configs"
files=($(ls config | grep '\.conf$'))
count=$(ls config | grep '\.conf$' | wc -l)
servers=""
echo "$count config files found."

# generate docker-compose.yaml and download server.jar
printTitle "Generate docker-compose.yaml and download server.jar"
> src/web/backend/servers.txt
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
    wget -4 ${download_link} -O "./data/${server_name}/server.jar"
    echo "${server_name}" >> src/web/backend/servers.txt
    # check firewall
    if [ $firewall ]
    then
        echo "Firewall is enabled, allow traffic to $port"
        if [ $os = "centos" ]
        then
            firewall-cmd --add-port="$port/tcp" --permanent
            firewall-cmd --reload
        else
            ufw allow to any port $port
        fi
    fi
done
cat > docker-compose.yaml <<EOF
version: "2"
networks:
  net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.16.57.0/24

services:
EOF
echo -e "$servers" >> docker-compose.yaml
printOK "Done."

# generate server files by running docker-compose
printTitle "Generate necessary server files"
systemctl start docker
docker-compose up -d
printOK "Done"

# wait for server files created
printTitle "Wait for server files created"
sleep 5

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
    echo "enable-rcon=true" >> data/${f%.*}/server.properties
    echo "rcon.password=123456" >> data/${f%.*}/server.properties
done
printOK "Done"

