import '../entities/task_analytics_entity.dart';
import '../repositories/task_repository.dart';

class GetAnalyticsUseCase {
  final TaskRepository repository;
  GetAnalyticsUseCase(this.repository);
  Future<TaskAnalyticsEntity> call() => repository.getAnalytics();
}
