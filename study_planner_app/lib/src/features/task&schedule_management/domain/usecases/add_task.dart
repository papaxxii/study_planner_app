import 'package:dartz/dartz.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';
import '../../../../../core/errors/failure.dart';

class AddTask {
  final TaskRepository repository;
  AddTask(this.repository);

  Future<Either<Failure, void>> call(TaskEntity task) async {
    return await repository.addTask(task);
  }
}
