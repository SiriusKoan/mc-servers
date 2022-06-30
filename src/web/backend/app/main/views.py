from os.path import exists
from flask import jsonify
from . import main_bp
from .helper import get_seed, get_status


@main_bp.before_app_first_request
def check_servers_file():
    if not exists("servers.txt"):
        print("servers.txt does not exist.")
        raise RuntimeError
    else:
        print("servers.txt exists.")


@main_bp.route("/api/all", methods=["GET"])
def get_all_servers_api():
    with open("servers.txt", "r") as f:
        c = f.read().split("\n")
    c = [i for i in c if i]
    return jsonify(c)


@main_bp.route("/api/<string:server_name>", methods=["GET"])
def get_server_info_api(server_name):
    seed = get_seed(server_name)
    online, M, players = get_status(server_name)
    return {
        "name": server_name,
        "seed": seed,
        "online": online,
        "max": M,
        "players": players,
    }
