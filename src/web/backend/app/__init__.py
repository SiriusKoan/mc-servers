from flask import Flask
from .config import config


def create_app(env):
    app = Flask(__name__, template_folder="../templates", static_folder="../static")
    app.config.from_object(config[env])

    from .main import main_bp

    app.register_blueprint(main_bp)

    return app
