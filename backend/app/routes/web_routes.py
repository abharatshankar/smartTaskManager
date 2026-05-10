
from flask import Blueprint, render_template, redirect, url_for
from flask_jwt_extended import verify_jwt_in_request

web_bp = Blueprint("web", __name__)

@web_bp.route("/")
def home():
    return redirect(url_for("web.login"))

@web_bp.route("/login")
def login():
    return render_template("login.html")

@web_bp.route("/register")
def register():
    return render_template("register.html")

@web_bp.route("/dashboard")
def dashboard():
    try:
        verify_jwt_in_request()
    except Exception:
        return redirect(url_for("web.login"))
    return render_template("dashboard.html")
