import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class CreateTaskUseCase {
  final TaskRepository repository;
  CreateTaskUseCase(this.repository);
  Future<TaskEntity> call({required String title, required String description, required String priority, required String status}) {
    return repository.createTask(title: title, description: description, priority: priority, status: status);
  }
}
