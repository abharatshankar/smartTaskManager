import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String priority;
  final String status;
  final String createdDate;
  final String updatedAt;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdDate,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, title, description, priority, status, createdDate, updatedAt];
}
