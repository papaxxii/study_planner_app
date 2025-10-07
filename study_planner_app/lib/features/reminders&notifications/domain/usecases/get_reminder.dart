import 'package:dartz/dartz.dart';
import '../../../task&schedule_management/domain/usecases/failure.dart';
import '../entities/reminders_notifications.dart';
import '../repositories/reminders_notifications_repo.dart';

class GetReminders {
  final ReminderRepository repository;
  GetReminders(this.repository);

  Future<Either<Failure, List<Reminder>>> call() {
    return repository.getReminders();
  }
}