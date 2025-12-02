import 'package:dartz/dartz.dart';
import '../entities/task_entity.dart';
import '../../../../../core/errors/failure.dart';

abstract class TaskRepository {
  Future<Either<Failure, void>> addTask(TaskEntity task);
  Future<Either<Failure, void>> updateTask(TaskEntity task);
  Future<Either<Failure, void>> deleteTask(String taskId);
  Future<Either<Failure, List<TaskEntity>>> getAllTasks(String userId);
  Future<Either<Failure, List<TaskEntity>>> getTasksByDate(
    String userId,
    DateTime date,
  );
}
