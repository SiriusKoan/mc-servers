# mc-servers
A simple tool to host many Minecraft servers on same host with Docker

## Usage
1. Install an Ubuntu or CentOS server. The instruction will be on Ubuntu.

2. Install git if it hasn't been installed.
```
$ sudo apt install git
```

3. Clone this project.
```
$ git clone https://github.com/SiriusKoan/mc-servers.git
```

4. Configure the servers. Edit the `.conf` files under `config` directory. The section below will introduce how to configure the servers.

5. Run `setup.sh` with root privilege.
```
$ sudo ./setup.sh
```

6. Wait for the process over, and run the following command to see whether `State` is `Up`.
```
$ sudo docker-compose ps
```

7. (Optional) Setup dashboard, and then you can connect to the server with HTTP (port 80) to see it.
```
$ sudo docker-compose -f docker-compose-web.yaml up -d
```

## Screenshot
![image](https://user-images.githubusercontent.com/26023540/177333894-3a411717-3919-4919-b8b3-99d1b93cd515.png)
