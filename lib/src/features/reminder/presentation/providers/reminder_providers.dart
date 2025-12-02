import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/reminder_remote_data_source.dart';
import '../../data/datasources/reminder_remote_data_source_impl.dart';
import '../../data/repository/reminder_repository_impl.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../domain/usecases/create_reminder.dart';
import '../../domain/usecases/delete_reminder.dart';
import '../../domain/usecases/get_user_reminder.dart';
import '../../domain/usecases/send_notification.dart';
import '../state/reminder_state.dart';
import '../state/reminder_notifier.dart';

// ==============================================================================
// Firebase Dependencies
// ==============================================================================

/// Provider for FirebaseFirestore instance
final reminderFirestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

// ==============================================================================
// Data Layer Providers
// ==============================================================================

/// Provider for ReminderRemoteDataSource
final reminderRemoteDataSourceProvider = Provider<ReminderRemoteDataSource>((
  ref,
) {
  final firestore = ref.watch(reminderFirestoreProvider);
  return ReminderRemoteDataSourceImpl(firestore: firestore);
});

// ==============================================================================
// Domain Layer Providers (Repository)
// ==============================================================================

/// Provider for ReminderRepository
final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final remoteDataSource = ref.watch(reminderRemoteDataSourceProvider);
  return ReminderRepositoryImpl(remoteDataSource);
});

// ==============================================================================
// Domain Layer Providers (Use Cases)
// ==============================================================================

/// Provider for CreateReminder use case
final createReminderProvider = Provider<CreateReminder>((ref) {
  final repository = ref.watch(reminderRepositoryProvider);
  return CreateReminder(repository);
});

/// Provider for DeleteReminder use case
final deleteReminderProvider = Provider<DeleteReminder>((ref) {
  final repository = ref.watch(reminderRepositoryProvider);
  return DeleteReminder(repository);
});

/// Provider for GetUserReminders use case
final getUserRemindersProvider = Provider<GetUserReminders>((ref) {
  final repository = ref.watch(reminderRepositoryProvider);
  return GetUserReminders(repository);
});

/// Provider for SendNotification use case
final sendNotificationProvider = Provider<SendNotification>((ref) {
  final repository = ref.watch(reminderRepositoryProvider);
  return SendNotification(repository);
});

// ==============================================================================
// Presentation Layer Providers (Notifier)
// ==============================================================================

/// Notifier provider that manages reminder state
/// Use this to access and modify reminder state throughout the app
final reminderStateProvider = NotifierProvider<ReminderNotifier, ReminderState>(
  () => ReminderNotifier(),
);
