import 'package:dartz/dartz.dart';
import '../entities/reminder_entity.dart';
import '../repositories/reminder_repository.dart';
import '../../../../../core/errors/failure.dart';

class CreateReminder {
  final ReminderRepository repository;
  CreateReminder(this.repository);

  Future<Either<Failure, void>> call(ReminderEntity reminder) async {
    return await repository.createReminder(reminder);
  }
}
