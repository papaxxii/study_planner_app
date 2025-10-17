import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/entities/progress_entity.dart';
import '../datasources/progress_remote_data_source.dart';
import '../models/progress_model.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressRemoteDataSource remoteDataSource;

  ProgressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProgressEntity>> getUserProgress(String userId) async {
    try {
      final model = await remoteDataSource.getUserProgress(userId);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProgressEntity>> getDailyProgress(
    String userId,
    DateTime date,
  ) async {
    try {
      final model = await remoteDataSource.getDailyProgress(userId, date);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProgress(
    String userId,
    ProgressEntity progress,
  ) async {
    try {
      final model = ProgressModel(
        userId: progress.userId,
        totalTasks: progress.totalTasks,
        completedTasks: progress.completedTasks,
        completionRate: progress.completionRate,
        currentStreakDays: progress.currentStreakDays,
        lastUpdated: progress.lastUpdated,
      );

      // Update using userId as document id; data source will create if missing
      await remoteDataSource.updateProgress(userId, model);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
