from flask import Flask

def create_app(env):
    app = Flask(__name__, template_folder="../templates", static_folder="../static")
    app.config.from_object(config[env])

    from .main import main_bp
    app.register_blueprint(main_bp)

    return app
