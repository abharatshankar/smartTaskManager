import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.priority,
    required super.status,
    required super.createdDate,
    required super.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] is int ? json['id'] as int : int.parse('${json['id']}'),
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      priority: (json['priority'] ?? 'Medium') as String,
      status: (json['status'] ?? 'Pending') as String,
      createdDate: (json['created_date'] ?? '') as String,
      updatedAt: (json['updated_at'] ?? json['created_date'] ?? '') as String,
    );
  }
}
