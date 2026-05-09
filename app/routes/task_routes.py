
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.extensions import db, socketio
from app.models.task import Task

task_bp = Blueprint("tasks", __name__)

@task_bp.route("", methods=["GET"])
@jwt_required()
def get_tasks():
    user_id = get_jwt_identity()
    tasks = Task.query.filter_by(user_id=user_id).all()
    return jsonify([task.to_dict() for task in tasks])

@task_bp.route("", methods=["POST"])
@jwt_required()
def create_task():
    user_id = get_jwt_identity()
    data = request.get_json()

    task = Task(
        title=data["title"],
        description=data.get("description"),
        priority=data.get("priority", "Medium"),
        status=data.get("status", "Pending"),
        user_id=user_id
    )

    db.session.add(task)
    db.session.commit()

    socketio.emit("task_update", {
        "message": "New task created",
        "task": task.to_dict()
    })

    return jsonify(task.to_dict()), 201

@task_bp.route("/<int:task_id>", methods=["PUT"])
@jwt_required()
def update_task(task_id):
    task = Task.query.get_or_404(task_id)
    data = request.get_json()

    task.title = data.get("title", task.title)
    task.description = data.get("description", task.description)
    task.priority = data.get("priority", task.priority)
    task.status = data.get("status", task.status)

    db.session.commit()

    socketio.emit("task_update", {
        "message": "Task updated",
        "task": task.to_dict()
    })

    return jsonify(task.to_dict())

@task_bp.route("/<int:task_id>", methods=["DELETE"])
@jwt_required()
def delete_task(task_id):
    task = Task.query.get_or_404(task_id)

    db.session.delete(task)
    db.session.commit()

    socketio.emit("task_update", {
        "message": "Task deleted",
        "task_id": task_id
    })

    return jsonify({"message": "Task deleted successfully"})
