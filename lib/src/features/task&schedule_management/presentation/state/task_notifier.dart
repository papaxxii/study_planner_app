import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_all_task.dart';
import '../../domain/usecases/get_task_by_date.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/datasources/task_remote_data_source.dart';
import '../../data/datasources/task_remote_data_source_impl.dart';
import '../../data/repository/task_repository_impl.dart';
import 'task_state.dart';

// ==============================================================================
// Private Providers
// ==============================================================================

final _taskFirestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

final _taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  final firestore = ref.watch(_taskFirestoreProvider);
  return TaskRemoteDataSourceImpl(firestore: firestore);
});

final _taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final remoteDataSource = ref.watch(_taskRemoteDataSourceProvider);
  return TaskRepositoryImpl(remoteDataSource);
});

final _addTaskProvider = Provider<AddTask>((ref) {
  final repository = ref.watch(_taskRepositoryProvider);
  return AddTask(repository);
});

final _updateTaskProvider = Provider<UpdateTask>((ref) {
  final repository = ref.watch(_taskRepositoryProvider);
  return UpdateTask(repository);
});

final _deleteTaskProvider = Provider<DeleteTask>((ref) {
  final repository = ref.watch(_taskRepositoryProvider);
  return DeleteTask(repository);
});

final _getAllTasksProvider = Provider<GetAllTasks>((ref) {
  final repository = ref.watch(_taskRepositoryProvider);
  return GetAllTasks(repository);
});

final _getTasksByDateProvider = Provider<GetTasksByDate>((ref) {
  final repository = ref.watch(_taskRepositoryProvider);
  return GetTasksByDate(repository);
});

// ==============================================================================
// Notifier
// ==============================================================================

/// Notifier for managing task state
class TaskNotifier extends Notifier<TaskState> {
  // Use cases - initialized lazily when needed
  late final AddTask _addTask;
  late final UpdateTask _updateTask;
  late final DeleteTask _deleteTask;
  late final GetAllTasks _getAllTasks;
  late final GetTasksByDate _getTasksByDate;

  @override
  TaskState build() {
    // Initialize use cases from providers
    _addTask = ref.watch(_addTaskProvider);
    _updateTask = ref.watch(_updateTaskProvider);
    _deleteTask = ref.watch(_deleteTaskProvider);
    _getAllTasks = ref.watch(_getAllTasksProvider);
    _getTasksByDate = ref.watch(_getTasksByDateProvider);

    return const TaskInitial();
  }

  /// Add a new task
  Future<void> addTask(TaskEntity task) async {
    state = const TaskLoading();
    final result = await _addTask(task);

    result.fold(
      (failure) => state = TaskError(failure.message),
      (_) => state = TaskAddSuccess('Task added successfully'),
    );
  }

  /// Update an existing task
  Future<void> updateTask(TaskEntity task) async {
    state = const TaskLoading();
    final result = await _updateTask(task);

    result.fold(
      (failure) => state = TaskError(failure.message),
      (_) => state = TaskUpdateSuccess('Task updated successfully'),
    );
  }

  /// Delete a task by ID
  Future<void> deleteTask(String taskId) async {
    state = const TaskLoading();
    final result = await _deleteTask(taskId);

    result.fold(
      (failure) => state = TaskError(failure.message),
      (_) => state = TaskDeleteSuccess(taskId),
    );
  }

  /// Fetch all tasks for a user
  Future<void> fetchAllTasks(String userId) async {
    state = const TaskLoading();
    final result = await _getAllTasks(userId);

    result.fold(
      (failure) => state = TaskError(failure.message),
      (tasks) => state = TaskSuccess(tasks),
    );
  }

  /// Fetch tasks for a user by date
  Future<void> fetchTasksByDate(String userId, DateTime date) async {
    state = const TaskLoading();
    final result = await _getTasksByDate(userId, date);

    result.fold(
      (failure) => state = TaskError(failure.message),
      (tasks) => state = TaskSuccess(tasks),
    );
  }

  /// Reset to initial state
  void resetState() {
    state = const TaskInitial();
  }
}

// ==============================================================================
// Presentation Layer Providers
// ==============================================================================

/// Notifier provider that manages task state
/// Use this to access and modify task state throughout the app
final taskStateProvider = NotifierProvider<TaskNotifier, TaskState>(
  () => TaskNotifier(),
);
