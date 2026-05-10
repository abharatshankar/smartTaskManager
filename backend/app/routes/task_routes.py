
from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.extensions import db, socketio
from app.models.task import Task

task_bp = Blueprint("tasks", __name__)

def current_user_id() -> int:
    return int(get_jwt_identity())

@task_bp.route("", methods=["GET"])
@task_bp.route("/", methods=["GET"])
@jwt_required()
def get_tasks():
    user_id = current_user_id()
    tasks = (
        Task.query
        .filter_by(user_id=user_id)
        .order_by(Task.created_date.desc())
        .all()
    )
    return jsonify([task.to_dict() for task in tasks]), 200

@task_bp.route("", methods=["POST"])
@task_bp.route("/", methods=["POST"])
@jwt_required()
def create_task():
    try:
        user_id = current_user_id()
        data = request.get_json(silent=True) or {}

        title = (data.get("title") or "").strip()
        if not title:
            return jsonify({"message": "Task title is required"}), 400

        task = Task(
            title=title,
            description=(data.get("description") or "").strip(),
            priority=(data.get("priority") or "Medium").strip(),
            status=(data.get("status") or "Pending").strip(),
            user_id=user_id
        )

        db.session.add(task)
        db.session.commit()

        payload = task.to_dict()
        socketio.emit("task_update", {"message": "Task created successfully", "task": payload})
        return jsonify(payload), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"message": "Task creation failed", "error": str(e)}), 500

@task_bp.route("/<int:task_id>", methods=["PUT"])
@jwt_required()
def update_task(task_id):
    try:
        user_id = current_user_id()
        task = Task.query.filter_by(id=task_id, user_id=user_id).first_or_404()
        data = request.get_json(silent=True) or {}

        title = (data.get("title") or "").strip()
        if not title:
            return jsonify({"message": "Task title is required"}), 400

        task.title = title
        task.description = (data.get("description") or "").strip()
        task.priority = (data.get("priority") or "Medium").strip()
        task.status = (data.get("status") or "Pending").strip()

        db.session.commit()

        payload = task.to_dict()
        socketio.emit("task_update", {"message": "Task updated successfully", "task": payload})
        return jsonify(payload), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({"message": "Task update failed", "error": str(e)}), 500

@task_bp.route("/<int:task_id>", methods=["DELETE"])
@jwt_required()
def delete_task(task_id):
    try:
        user_id = current_user_id()
        task = Task.query.filter_by(id=task_id, user_id=user_id).first_or_404()

        db.session.delete(task)
        db.session.commit()

        socketio.emit("task_update", {"message": "Task deleted successfully", "task_id": task_id})
        return jsonify({"message": "Task deleted successfully"}), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({"message": "Task deletion failed", "error": str(e)}), 500
