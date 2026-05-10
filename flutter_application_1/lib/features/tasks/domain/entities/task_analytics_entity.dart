import 'package:equatable/equatable.dart';

class TaskAnalyticsEntity extends Equatable {
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final double completionPercentage;

  const TaskAnalyticsEntity({
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.completionPercentage,
  });

  @override
  List<Object?> get props => [totalTasks, completedTasks, pendingTasks, completionPercentage];
}
