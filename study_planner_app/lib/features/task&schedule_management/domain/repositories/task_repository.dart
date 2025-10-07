
import 'package:dartz/dartz.dart';
import '../usecases/failure.dart';

abstract class TaskRepository {
  Future<Either<Failure, Task>> addTask(Task task);
  Future<Either<Failure, List<Task>>> getTasks();
  Future<Either<Failure, Task>> updateTask(Task task);
  Future<Either<Failure, void>> deleteTask(String id);
  Future<Either<Failure, Task>> markTaskComplete(String id);

  Future<Either<Failure, Task>> getTaskById(String taskId);
}

