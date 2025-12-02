import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/reminder_entity.dart';
import '../../domain/usecases/create_reminder.dart';
import '../../domain/usecases/delete_reminder.dart';
import '../../domain/usecases/get_user_reminder.dart';
import '../../domain/usecases/send_notification.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../data/datasources/reminder_remote_data_source.dart';
import '../../data/datasources/reminder_remote_data_source_impl.dart';
import '../../data/repository/reminder_repository_impl.dart';
import 'reminder_state.dart';

// ==============================================================================
// Private Providers
// ==============================================================================

final _reminderFirestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

final _reminderRemoteDataSourceProvider = Provider<ReminderRemoteDataSource>((
  ref,
) {
  final firestore = ref.watch(_reminderFirestoreProvider);
  return ReminderRemoteDataSourceImpl(firestore: firestore);
});

final _reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final remoteDataSource = ref.watch(_reminderRemoteDataSourceProvider);
  return ReminderRepositoryImpl(remoteDataSource);
});

final _createReminderProvider = Provider<CreateReminder>((ref) {
  final repository = ref.watch(_reminderRepositoryProvider);
  return CreateReminder(repository);
});

final _deleteReminderProvider = Provider<DeleteReminder>((ref) {
  final repository = ref.watch(_reminderRepositoryProvider);
  return DeleteReminder(repository);
});

final _getUserRemindersProvider = Provider<GetUserReminders>((ref) {
  final repository = ref.watch(_reminderRepositoryProvider);
  return GetUserReminders(repository);
});

final _sendNotificationProvider = Provider<SendNotification>((ref) {
  final repository = ref.watch(_reminderRepositoryProvider);
  return SendNotification(repository);
});

// ==============================================================================
// Notifier
// ==============================================================================

/// Notifier for managing reminder state
class ReminderNotifier extends Notifier<ReminderState> {
  // Use cases - initialized lazily when needed
  late final CreateReminder _createReminder;
  late final DeleteReminder _deleteReminder;
  late final GetUserReminders _getUserReminders;
  late final SendNotification _sendNotification;

  @override
  ReminderState build() {
    // Initialize use cases from providers
    _createReminder = ref.watch(_createReminderProvider);
    _deleteReminder = ref.watch(_deleteReminderProvider);
    _getUserReminders = ref.watch(_getUserRemindersProvider);
    _sendNotification = ref.watch(_sendNotificationProvider);

    return const ReminderInitial();
  }

  /// Create a new reminder
  Future<void> createReminder(ReminderEntity reminder) async {
    state = const ReminderLoading();
    final result = await _createReminder(reminder);

    result.fold(
      (failure) => state = ReminderError(failure.message),
      (_) => state = ReminderCreateSuccess('Reminder created successfully'),
    );
  }

  /// Fetch all reminders for a user
  Future<void> fetchUserReminders(String userId) async {
    state = const ReminderLoading();
    final result = await _getUserReminders(userId);

    result.fold(
      (failure) => state = ReminderError(failure.message),
      (reminders) => state = ReminderSuccess(reminders),
    );
  }

  /// Delete a reminder by ID
  Future<void> deleteReminder(String reminderId) async {
    state = const ReminderLoading();
    final result = await _deleteReminder(reminderId);

    result.fold(
      (failure) => state = ReminderError(failure.message),
      (_) => state = ReminderDeleteSuccess(reminderId),
    );
  }

  /// Send a notification
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    DateTime? scheduledTime,
  }) async {
    state = const ReminderLoading();
    final result = await _sendNotification(
      userId: userId,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
    );

    result.fold(
      (failure) => state = ReminderError(failure.message),
      (_) => state = NotificationSentSuccess('Notification sent successfully'),
    );
  }

  /// Reset to initial state
  void resetState() {
    state = const ReminderInitial();
  }
}

// ==============================================================================
// Presentation Layer Providers
// ==============================================================================

/// Notifier provider that manages reminder state
/// Use this to access and modify reminder state throughout the app
final reminderStateProvider = NotifierProvider<ReminderNotifier, ReminderState>(
  () => ReminderNotifier(),
);
