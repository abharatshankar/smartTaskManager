import '../../domain/entities/task_analytics_entity.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TaskEntity>> getTasks() => remoteDataSource.getTasks();

  @override
  Future<TaskEntity> createTask({required String title, required String description, required String priority, required String status}) {
    return remoteDataSource.createTask({'title': title, 'description': description, 'priority': priority, 'status': status});
  }

  @override
  Future<TaskEntity> updateTask({required int id, required String title, required String description, required String priority, required String status}) {
    return remoteDataSource.updateTask(id, {'title': title, 'description': description, 'priority': priority, 'status': status});
  }

  @override
  Future<void> deleteTask(int id) => remoteDataSource.deleteTask(id);

  @override
  Future<TaskAnalyticsEntity> getAnalytics() async {
    final data = await remoteDataSource.getAnalyticsRaw();
    return TaskAnalyticsEntity(
      totalTasks: (data['total_tasks'] ?? 0) as int,
      completedTasks: (data['completed_tasks'] ?? 0) as int,
      pendingTasks: (data['pending_tasks'] ?? 0) as int,
      completionPercentage: (data['completion_percentage'] as num?)?.toDouble() ?? 0,
    );
  }
}
