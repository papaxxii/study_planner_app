import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reminder_model.dart';
import 'reminder_remote_data_source.dart';

class ReminderRemoteDataSourceImpl implements ReminderRemoteDataSource {
  final FirebaseFirestore firestore;

  ReminderRemoteDataSourceImpl({required this.firestore});

  CollectionReference get reminderCollection =>
      firestore.collection('reminders');

  CollectionReference get notificationCollection =>
      firestore.collection('notifications');

  @override
  Future<void> createReminder(ReminderModel reminder) async {
    await reminderCollection.doc(reminder.id).set(reminder.toMap());
  }

  @override
  Future<void> deleteReminder(String reminderId) async {
    await reminderCollection.doc(reminderId).delete();
  }

  @override
  Future<List<ReminderModel>> getUserReminders(String userId) async {
    final snapshot = await reminderCollection
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map(
          (doc) => ReminderModel.fromFirebase(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();
  }

  @override
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    DateTime? scheduledTime,
  }) async {
    // Store a notification request; an external function/Cloud Function can handle delivery
    await notificationCollection.add({
      'userId': userId,
      'title': title,
      'body': body,
      'scheduledTime': scheduledTime != null
          ? Timestamp.fromDate(scheduledTime)
          : null,
      'createdAt': Timestamp.now(),
    });
  }
}
