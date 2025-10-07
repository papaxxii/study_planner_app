import 'package:dartz/dartz.dart';
// ignore: unused_import
import '../entities/task.dart' hide Task;
import '../repositories/task_repository.dart';
import 'failure.dart';

class GetTasks {
  final TaskRepository repository;
  GetTasks(this.repository);

  Future<Either<Failure, List<Task>>> call() async {
    return await repository.getTasks();
  }
}