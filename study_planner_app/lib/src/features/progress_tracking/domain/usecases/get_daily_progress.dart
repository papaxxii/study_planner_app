import 'package:dartz/dartz.dart';
import '../entities/progress_entity.dart';
import '../repositories/progress_repository.dart';
import '../../../../../core/errors/failure.dart';

class GetDailyProgress {
  final ProgressRepository repository;
  GetDailyProgress(this.repository);

  Future<Either<Failure, ProgressEntity>> call(
    String userId,
    DateTime date,
  ) async {
    return await repository.getDailyProgress(userId, date);
  }
}
