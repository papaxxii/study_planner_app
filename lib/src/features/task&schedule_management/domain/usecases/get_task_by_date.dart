import 'package:dartz/dartz.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';
import '../../../../../core/errors/failure.dart';

class GetTasksByDate {
  final TaskRepository repository;
  GetTasksByDate(this.repository);

  Future<Either<Failure, List<TaskEntity>>> call(String userId, DateTime date) async {
    return await repository.getTasksByDate(userId, date);
  }
}
