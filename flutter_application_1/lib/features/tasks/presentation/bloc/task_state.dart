import 'package:equatable/equatable.dart';
import '../../domain/entities/task_analytics_entity.dart';
import '../../domain/entities/task_entity.dart';

class TaskState extends Equatable {
  final bool loading;
  final List<TaskEntity> tasks;
  final TaskAnalyticsEntity analytics;
  final String? message;

  const TaskState({
    this.loading = false,
    this.tasks = const [],
    this.analytics = const TaskAnalyticsEntity(totalTasks: 0, completedTasks: 0, pendingTasks: 0, completionPercentage: 0),
    this.message,
  });

  TaskState copyWith({bool? loading, List<TaskEntity>? tasks, TaskAnalyticsEntity? analytics, String? message}) {
    return TaskState(
      loading: loading ?? this.loading,
      tasks: tasks ?? this.tasks,
      analytics: analytics ?? this.analytics,
      message: message,
    );
  }

  @override
  List<Object?> get props => [loading, tasks, analytics, message];
}
