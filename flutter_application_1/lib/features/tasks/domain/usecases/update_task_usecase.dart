import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository repository;
  UpdateTaskUseCase(this.repository);
  Future<TaskEntity> call({required int id, required String title, required String description, required String priority, required String status}) {
    return repository.updateTask(id: id, title: title, description: description, priority: priority, status: status);
  }
}
