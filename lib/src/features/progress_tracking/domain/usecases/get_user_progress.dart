import 'package:dartz/dartz.dart';
import '../entities/progress_entity.dart';
import '../repositories/progress_repository.dart';
import '../../../../../core/errors/failure.dart';

class GetUserProgress {
  final ProgressRepository repository;
  GetUserProgress(this.repository);

  Future<Either<Failure, ProgressEntity>> call(String userId) async {
    return await repository.getUserProgress(userId);
  }
}
