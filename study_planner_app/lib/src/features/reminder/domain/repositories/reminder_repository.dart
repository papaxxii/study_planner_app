import 'package:dartz/dartz.dart';
import '../entities/reminder_entity.dart';
import '../../../../../core/errors/failure.dart';

abstract class ReminderRepository {
  /// Create or update a reminder for a user
  Future<Either<Failure, void>> createReminder(ReminderEntity reminder);

  /// Get all reminders for a specific user
  Future<Either<Failure, List<ReminderEntity>>> getUserReminders(String userId);

  /// Delete a specific reminder by ID
  Future<Either<Failure, void>> deleteReminder(String reminderId);

  /// Send a notification (can be scheduled or immediate)
  Future<Either<Failure, void>> sendNotification({
    required String userId,
    required String title,
    required String body,
    DateTime? scheduledTime,
  });
}
