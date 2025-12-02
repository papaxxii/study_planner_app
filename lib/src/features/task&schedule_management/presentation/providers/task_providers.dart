import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/task_remote_data_source.dart';
import '../../data/datasources/task_remote_data_source_impl.dart';
import '../../data/repository/task_repository_impl.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_all_task.dart';
import '../../domain/usecases/get_task_by_date.dart';
import '../state/task_state.dart';
import '../state/task_notifier.dart';

// ==============================================================================
// Firebase Dependencies
// ==============================================================================

/// Provider for FirebaseFirestore instance
final taskFirestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

// ==============================================================================
// Data Layer Providers
// ==============================================================================

/// Provider for TaskRemoteDataSource
final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  final firestore = ref.watch(taskFirestoreProvider);
  return TaskRemoteDataSourceImpl(firestore: firestore);
});

// ==============================================================================
// Domain Layer Providers (Repository)
// ==============================================================================

/// Provider for TaskRepository
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final remoteDataSource = ref.watch(taskRemoteDataSourceProvider);
  return TaskRepositoryImpl(remoteDataSource);
});

// ==============================================================================
// Domain Layer Providers (Use Cases)
// ==============================================================================

/// Provider for AddTask use case
final addTaskProvider = Provider<AddTask>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return AddTask(repository);
});

/// Provider for UpdateTask use case
final updateTaskProvider = Provider<UpdateTask>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return UpdateTask(repository);
});

/// Provider for DeleteTask use case
final deleteTaskProvider = Provider<DeleteTask>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return DeleteTask(repository);
});

/// Provider for GetAllTasks use case
final getAllTasksProvider = Provider<GetAllTasks>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return GetAllTasks(repository);
});

/// Provider for GetTasksByDate use case
final getTasksByDateProvider = Provider<GetTasksByDate>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return GetTasksByDate(repository);
});

// ==============================================================================
// Presentation Layer Providers (Notifier)
// ==============================================================================

/// Notifier provider that manages task state
/// Use this to access and modify task state throughout the app
final taskStateProvider = NotifierProvider<TaskNotifier, TaskState>(
  () => TaskNotifier(),
);
