import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_analytics_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final GetTasksUseCase getTasksUseCase;
  final CreateTaskUseCase createTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final GetAnalyticsUseCase getAnalyticsUseCase;

  TaskCubit({required this.getTasksUseCase, required this.createTaskUseCase, required this.updateTaskUseCase, required this.deleteTaskUseCase, required this.getAnalyticsUseCase}) : super(const TaskState());

  Future<void> loadDashboard() async {
    emit(state.copyWith(loading: true, message: null));
    try {
      final tasks = await getTasksUseCase();
      final analytics = await getAnalyticsUseCase();
      emit(state.copyWith(loading: false, tasks: tasks, analytics: analytics));
    } catch (e) {
      emit(state.copyWith(loading: false, message: e.toString()));
    }
  }

  Future<void> createTask({required String title, required String description, required String priority, required String status}) async {
    emit(state.copyWith(loading: true, message: null));
    try {
      await createTaskUseCase(title: title, description: description, priority: priority, status: status);
      await loadDashboard();
    } catch (e) {
      emit(state.copyWith(loading: false, message: e.toString()));
    }
  }

  Future<void> updateTask({required int id, required String title, required String description, required String priority, required String status}) async {
    emit(state.copyWith(loading: true, message: null));
    try {
      await updateTaskUseCase(id: id, title: title, description: description, priority: priority, status: status);
      await loadDashboard();
    } catch (e) {
      emit(state.copyWith(loading: false, message: e.toString()));
    }
  }

  Future<void> deleteTask(int id) async {
    emit(state.copyWith(loading: true, message: null));
    try {
      await deleteTaskUseCase(id);
      await loadDashboard();
    } catch (e) {
      emit(state.copyWith(loading: false, message: e.toString()));
    }
  }
}
