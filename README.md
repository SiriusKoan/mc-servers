# mc-servers
A simple tool to host many Minecraft servers on same host with Docker

## Instructions
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

## Config
You can put several config files in `config`. There are two examples (`mc1.conf` and `mc2.conf`) in `config`, and if you don't need them, please remove them, or they will be created.

The first thing you should do is create a file named `abc.conf`, where `abc` is the name of server. It is an identifier, and only important to you, not to the system.

### `version`
In config file, the first line is the version of server. To see the full list of versions, check [mcversions](https://mcversions.net/) or `versions.txt`.

Please notice that `versions.txt` contains only **stable releases**. If you need other versions in snapshot preview, beta and alpha, please change the variable `only_stable` to `False` in `fetch.py` and run it to fetch full list of versions.

### `port`
The second line is the port to expose. Every server should have its own port.

### Others
The left lines will be written to `server.properties` directly, you can reference `config/server.properties`.

## Integration with Old Servers
If you already have a server, then you only need to give it a name (and create corresponding config file), set `version` and `port`, and run `setup.sh` as the instructions say.

After the process is over, move the whole directory to `data` directory and name it, but remember NOT to override `server.jar`.

## Screenshot
![image](https://user-images.githubusercontent.com/26023540/177333894-3a411717-3919-4919-b8b3-99d1b93cd515.png)
