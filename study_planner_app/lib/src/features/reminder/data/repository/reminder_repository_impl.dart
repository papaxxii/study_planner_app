import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../../domain/entities/reminder_entity.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../datasources/reminder_remote_data_source.dart';
import '../models/reminder_model.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderRemoteDataSource remoteDataSource;

  ReminderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> createReminder(ReminderEntity reminder) async {
    try {
      final model = ReminderModel(
        id: reminder.id,
        userId: reminder.userId,
        title: reminder.title,
        description: reminder.description,
        scheduledTime: reminder.scheduledTime,
        isCompleted: reminder.isCompleted,
        type: reminder.type,
      );
      await remoteDataSource.createReminder(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReminderEntity>>> getUserReminders(
    String userId,
  ) async {
    try {
      final models = await remoteDataSource.getUserReminders(userId);
      return Right(models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReminder(String reminderId) async {
    try {
      await remoteDataSource.deleteReminder(reminderId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendNotification({
    required String userId,
    required String title,
    required String body,
    DateTime? scheduledTime,
  }) async {
    try {
      await remoteDataSource.sendNotification(
        userId: userId,
        title: title,
        body: body,
        scheduledTime: scheduledTime,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
