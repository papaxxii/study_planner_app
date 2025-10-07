// ignore_for_file: unused_import

import 'package:dartz/dartz.dart';
import '../entities/task.dart' hide Task;
import '../repositories/task_repository.dart';
import 'failure.dart';

class UpdateTask {
  final TaskRepository repository;
  UpdateTask(this.repository);

  Future<Either<Failure, Task>> call(Task task) async {
    return await repository.updateTask(task);
  }
}