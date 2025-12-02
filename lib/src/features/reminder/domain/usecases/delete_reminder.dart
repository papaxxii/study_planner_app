import 'package:dartz/dartz.dart';
import '../repositories/reminder_repository.dart';
import '../../../../../core/errors/failure.dart';

class DeleteReminder {
  final ReminderRepository repository;
  DeleteReminder(this.repository);

  Future<Either<Failure, void>> call(String reminderId) async {
    return await repository.deleteReminder(reminderId);
  }
}
