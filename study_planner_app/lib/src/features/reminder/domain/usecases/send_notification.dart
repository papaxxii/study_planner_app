import 'package:dartz/dartz.dart';
import '../repositories/reminder_repository.dart';
import '../../../../../core/errors/failure.dart';

class SendNotification {
  final ReminderRepository repository;
  SendNotification(this.repository);

  Future<Either<Failure, void>> call({
    required String userId,
    required String title,
    required String body,
    DateTime? scheduledTime,
  }) async {
    return await repository.sendNotification(
      userId: userId,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
    );
  }
}
