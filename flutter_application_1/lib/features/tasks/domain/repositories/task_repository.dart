import '../entities/task_analytics_entity.dart';
import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks();
  Future<TaskEntity> createTask({required String title, required String description, required String priority, required String status});
  Future<TaskEntity> updateTask({required int id, required String title, required String description, required String priority, required String status});
  Future<void> deleteTask(int id);
  Future<TaskAnalyticsEntity> getAnalytics();
}
