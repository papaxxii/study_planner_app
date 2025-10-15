import 'package:dartz/dartz.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';
import '../../../../../core/errors/failure.dart';

class GetAllTasks {
  final TaskRepository repository;
  GetAllTasks(this.repository);

  Future<Either<Failure, List<TaskEntity>>> call(String userId) async {
    return await repository.getAllTasks(userId);
  }
}
