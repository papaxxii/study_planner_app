import 'package:dartz/dartz.dart';
import '../entities/progress_entity.dart';
import '../repositories/progress_repository.dart';
import '../../../../../core/errors/failure.dart';

class UpdateProgress {
  final ProgressRepository repository;
  UpdateProgress(this.repository);

  Future<Either<Failure, void>> call(
    String userId,
    ProgressEntity progress,
  ) async {
    return await repository.updateProgress(userId, progress);
  }
}
