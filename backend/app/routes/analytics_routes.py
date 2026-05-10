
import numpy as np
import pandas as pd
from flask import Blueprint, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.models.task import Task

analytics_bp = Blueprint("analytics", __name__)

@analytics_bp.route("", methods=["GET"])
@jwt_required()
def analytics():
    user_id = int(get_jwt_identity())
    tasks = Task.query.filter_by(user_id=user_id).all()

    if not tasks:
        return jsonify({
            "total_tasks": 0,
            "completed_tasks": 0,
            "pending_tasks": 0,
            "completion_percentage": 0
        }), 200

    df = pd.DataFrame([task.to_dict() for task in tasks])

    total_tasks = int(len(df))
    completed_tasks = int(np.sum(df["status"] == "Completed"))
    pending_tasks = int(np.sum(df["status"] != "Completed"))
    completion_percentage = round((completed_tasks / total_tasks) * 100, 2) if total_tasks else 0

    return jsonify({
        "total_tasks": total_tasks,
        "completed_tasks": completed_tasks,
        "pending_tasks": pending_tasks,
        "completion_percentage": completion_percentage
    }), 200
