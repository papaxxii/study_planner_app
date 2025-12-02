import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);

  /// Get all tasks for a user
  Future<List<TaskModel>> getAllTasks(String userId);

  /// Get tasks for a user by date
  Future<List<TaskModel>> getTasksByDate(String userId, DateTime date);
}
