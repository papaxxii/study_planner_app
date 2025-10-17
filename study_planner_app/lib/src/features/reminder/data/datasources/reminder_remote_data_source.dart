import '../models/reminder_model.dart';

abstract class ReminderRemoteDataSource {
  /// Create or update a reminder
  Future<void> createReminder(ReminderModel reminder);

  /// Get all reminders for a specific user
  Future<List<ReminderModel>> getUserReminders(String userId);

  /// Delete a specific reminder by ID
  Future<void> deleteReminder(String reminderId);

  /// Send a notification (stores a notification request or schedules it)
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    DateTime? scheduledTime,
  });
}
