import re
from mcipc.rcon.je import Client


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
        except Exception as e:
            return str(e)
