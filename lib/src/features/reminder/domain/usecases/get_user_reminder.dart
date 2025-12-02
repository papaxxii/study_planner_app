import 'package:dartz/dartz.dart';
import '../entities/reminder_entity.dart';
import '../repositories/reminder_repository.dart';
import '../../../../../core/errors/failure.dart';

class GetUserReminders {
  final ReminderRepository repository;
  GetUserReminders(this.repository);

  Future<Either<Failure, List<ReminderEntity>>> call(String userId) async {
    return await repository.getUserReminders(userId);
  }
}
