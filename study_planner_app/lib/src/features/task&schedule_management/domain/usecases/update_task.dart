import 'package:dartz/dartz.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';
import '../../../../../core/errors/failure.dart';

class UpdateTask {
  final TaskRepository repository;
  UpdateTask(this.repository);

  Future<Either<Failure, void>> call(TaskEntity task) async {
    return await repository.updateTask(task);
  }
}
