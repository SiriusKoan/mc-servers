import re
from mcipc.rcon.je import Client
import mcipc.rcon.errors


def test_rcon_connection(server_name):
    try:
        with Client(server_name, 25575, passwd="123456") as client:
            pass
        return True
    except:
        return False


def get_seed(server_name):
    with Client(server_name, 25575, passwd="123456") as client:
        return client.seed


def get_status(server_name):
    with Client(server_name, 25575, passwd="123456") as client:
        players_info = client.list()
        online = players_info.online
        M = players_info.max
        players = [player.name for player in players_info.players]
        return online, M, players


def send_command(server_name, command):
    with Client(server_name, 25575, passwd="123456") as client:
        try:
            return client.run(command)
        except mcipc.rcon.errors.UnknownCommand:
            return "Error: Unknown command", 400
        except mcipc.rcon.errors.InvalidArgument:
            return "Error: Invalid arguments", 400
        except:
            return "Error: Unknown error", 400
