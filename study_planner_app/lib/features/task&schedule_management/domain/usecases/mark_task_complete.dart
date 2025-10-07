import 'package:dartz/dartz.dart';
// ignore: unused_import
import '../entities/task.dart' hide Task;
import '../repositories/task_repository.dart';
import 'failure.dart';

class MarkTaskComplete {
  final TaskRepository repository;
  MarkTaskComplete(this.repository);

  Future<Either<Failure, Task>> call(String id) async {
    return await repository.markTaskComplete(id);
  }
}