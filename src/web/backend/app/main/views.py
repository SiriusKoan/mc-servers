from os.path import exists
from . import main_bp


def get_rcon_map():
    d = dict()
    with open("rcon.txt", "r") as f:
        line = f.readline()
        while line:
            server, port = line.split(":")
            d[server] = int(port)
    return d


@main_bp.before_app_first_request
def check_rcon_file():
    if not exists("rcon.txt"):
        print("rcon.txt does not exist.")
        exit(1)
    else:
        print("rcon.txt check OK")


@main_bp.route("/api/<string:server_name>", methods=["GET"])
def get_server_info_api(server_name):
    return server_name
