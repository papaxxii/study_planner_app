import 'package:dartz/dartz.dart';

import '../../../task&schedule_management/domain/usecases/failure.dart';
import '../entities/reminders_notifications.dart';
import '../repositories/reminders_notifications_repo.dart';

class UpdateReminder {
  final ReminderRepository repository;
  UpdateReminder(this.repository);

  Future<Either<Failure, Unit>> call(Reminder reminder) {
    return repository.updateReminder(reminder);
  }
}
