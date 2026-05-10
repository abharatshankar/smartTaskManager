import '../repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;
  DeleteTaskUseCase(this.repository);
  Future<void> call(int id) => repository.deleteTask(id);
}
