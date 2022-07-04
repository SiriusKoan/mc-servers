from os.path import exists
from flask import jsonify, request
from . import main_bp
from .helper import test_rcon_connection, get_seed, get_status, send_command


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
        content = f.read().split("\n")
    content = [c for c in content if c]
    res = dict()
    for server in content:
        res[server] = test_rcon_connection(server)
    return jsonify(res)


@main_bp.route("/api/<string:server_name>", methods=["GET", "POST"])
def get_server_info_api(server_name):
    if request.method == "GET":
        seed = get_seed(server_name)
        online, M, players = get_status(server_name)
        return {
            "name": server_name,
            "seed": seed,
            "online": online,
            "max": M,
            "players": players,
        }
    if request.method == "POST":
        data = request.get_json(force=True)
        command = data.get("command", None)
        if not command:
            return "Error: No command provided", 400
        return send_command(server_name, command)
