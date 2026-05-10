import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/task_model.dart';

class TaskRemoteDataSource {
  final ApiClient apiClient;
  TaskRemoteDataSource({required this.apiClient});

  Future<List<TaskModel>> getTasks() async {
    final data = await apiClient.get(ApiConstants.tasksPath);
    final list = (data as List).cast<Map<String, dynamic>>();
    return list.map(TaskModel.fromJson).toList();
  }

  Future<TaskModel> createTask(Map<String, dynamic> body) async {
    final data = await apiClient.post(ApiConstants.tasksPath, body);
    return TaskModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<TaskModel> updateTask(int id, Map<String, dynamic> body) async {
    final data = await apiClient.put('${ApiConstants.tasksPath}/$id', body);
    return TaskModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> deleteTask(int id) async {
    await apiClient.delete('${ApiConstants.tasksPath}/$id');
  }

  Future<Map<String, dynamic>> getAnalyticsRaw() async {
    final data = await apiClient.get(ApiConstants.analyticsPath);
    return Map<String, dynamic>.from(data);
  }
}
