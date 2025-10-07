import 'package:dartz/dartz.dart';
import 'package:study_planner_app/features/task&schedule_management/domain/usecases/failure.dart';
import '../entities/reminders_notifications.dart';

abstract class ReminderRepository {
  Future<Either<Failure, Unit>> addReminder(Reminder reminder);
  Future<Either<Failure, Unit>> updateReminder(Reminder reminder);
  Future<Either<Failure, Unit>> deleteReminder(String reminderId);
  Future<Either<Failure, List<Reminder>>> getReminders();
}
