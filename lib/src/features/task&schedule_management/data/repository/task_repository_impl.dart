import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> addTask(TaskEntity task) async {
    try {
      final model = TaskModel(
        id: task.id,
        userId: task.userId,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        isCompleted: task.isCompleted,
        priority: task.priority,
        reminderTime: task.reminderTime,
        goalType: task.goalType,
        createdAt: task.createdAt,
      );
      await remoteDataSource.addTask(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(TaskEntity task) async {
    try {
      final model = TaskModel(
        id: task.id,
        userId: task.userId,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        isCompleted: task.isCompleted,
        priority: task.priority,
        reminderTime: task.reminderTime,
        goalType: task.goalType,
        createdAt: task.createdAt,
      );
      await remoteDataSource.updateTask(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    try {
      await remoteDataSource.deleteTask(taskId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getAllTasks(String userId) async {
    try {
      final models = await remoteDataSource.getAllTasks(userId);
      return Right(models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasksByDate(
    String userId,
    DateTime date,
  ) async {
    try {
      final models = await remoteDataSource.getTasksByDate(userId, date);
      return Right(models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
