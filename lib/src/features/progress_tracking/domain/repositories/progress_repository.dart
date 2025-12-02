import 'package:dartz/dartz.dart';
import '../entities/progress_entity.dart';
import '../../../../../core/errors/failure.dart';

abstract class ProgressRepository {
  /// Get overall progress of the user (total tasks vs completed tasks)
  Future<Either<Failure, ProgressEntity>> getUserProgress(String userId);

  /// Get progress for a specific day (for daily insights or streak tracking)
  Future<Either<Failure, ProgressEntity>> getDailyProgress(String userId, DateTime date);

  /// Update progress whenever a task is marked complete or incomplete
  Future<Either<Failure, void>> updateProgress(String userId, ProgressEntity progress);
}
