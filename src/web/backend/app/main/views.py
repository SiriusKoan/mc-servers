from . import main_bp

@main_bp.route("/")
def index_page():
    return ""
