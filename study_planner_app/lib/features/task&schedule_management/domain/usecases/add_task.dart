import 'package:dartz/dartz.dart';
import '../entities/task.dart' as entity;
import '../repositories/task_repository.dart';
import 'failure.dart';

class AddTask {
  final TaskRepository repository;
  AddTask(this.repository);

  Future<Either<Failure, Task>> call(entity.Task task) async {
    return await repository.addTask(task as Task);
  }
}
