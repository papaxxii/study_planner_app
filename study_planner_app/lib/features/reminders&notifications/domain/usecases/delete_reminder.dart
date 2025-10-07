import 'package:dartz/dartz.dart';

import '../../../task&schedule_management/domain/usecases/failure.dart';
import '../repositories/reminders_notifications_repo.dart';

class DeleteReminder {
  final ReminderRepository repository;
  DeleteReminder(this.repository);

  Future<Either<Failure, Unit>> call(String reminderId) {
    return repository.deleteReminder(reminderId);
  }
}