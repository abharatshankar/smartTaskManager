
import pandas as pd
import numpy as np
from flask import Blueprint, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.models.task import Task

analytics_bp = Blueprint("analytics", __name__)

@analytics_bp.route("", methods=["GET"])
@jwt_required()
def analytics():
    user_id = get_jwt_identity()
    tasks = Task.query.filter_by(user_id=user_id).all()

    task_data = [task.to_dict() for task in tasks]

    if not task_data:
        return jsonify({
            "total_tasks": 0,
            "completed_tasks": 0,
            "pending_tasks": 0,
            "completion_percentage": 0
        })

    df = pd.DataFrame(task_data)

    total_tasks = int(len(df))
    completed_tasks = int(np.sum(df["status"] == "Completed"))
    pending_tasks = int(np.sum(df["status"] != "Completed"))

    completion_percentage = round(
        (completed_tasks / total_tasks) * 100, 2
    )

    return jsonify({
        "total_tasks": total_tasks,
        "completed_tasks": completed_tasks,
        "pending_tasks": pending_tasks,
        "completion_percentage": completion_percentage
    })
