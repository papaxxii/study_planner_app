import 'package:dartz/dartz.dart';

import '../repositories/task_repository.dart';
import 'failure.dart';

class GetTaskById {
  final TaskRepository repository;
  GetTaskById(this.repository);

  Future<Either<Failure, Task>> call(String taskId) {
    return repository.getTaskById(taskId);
  }
}