
from flask import Flask
from config import Config
from .extensions import db, jwt, socketio
from .routes.auth_routes import auth_bp
from .routes.task_routes import task_bp
from .routes.analytics_routes import analytics_bp
from .routes.web_routes import web_bp

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)
    jwt.init_app(app)
    socketio.init_app(app, cors_allowed_origins="*")

    app.register_blueprint(auth_bp, url_prefix="/api/auth")
    app.register_blueprint(task_bp, url_prefix="/api/tasks")
    app.register_blueprint(analytics_bp, url_prefix="/api/analytics")
    app.register_blueprint(web_bp)

    with app.app_context():
        db.create_all()

    return app
