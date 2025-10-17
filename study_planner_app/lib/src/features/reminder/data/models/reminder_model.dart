import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/reminder_entity.dart';

class ReminderModel extends ReminderEntity {
  const ReminderModel({
    required super.id,
    required super.userId,
    required super.title,
    super.description,
    required super.scheduledTime,
    required super.isCompleted,
    required super.type,
  });

  factory ReminderModel.fromFirebase(Map<String, dynamic> data, String id) {
    // Map string to ReminderType if stored as string
    ReminderType parseType(Object? value) {
      if (value is String) {
        if (value == 'task') return ReminderType.task;
        if (value == 'schedule') return ReminderType.schedule;
        if (value == 'custom') return ReminderType.custom;
      }
      return ReminderType.custom;
    }

    return ReminderModel(
      id: id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'],
      scheduledTime: data['scheduledTime'] is Timestamp
          ? (data['scheduledTime'] as Timestamp).toDate()
          : DateTime.parse(
              data['scheduledTime'] ?? DateTime.now().toIso8601String(),
            ),
      isCompleted: data['isCompleted'] ?? false,
      type: parseType(data['type']),
    );
  }

  Map<String, dynamic> toMap() {
    String typeToString(ReminderType t) {
      switch (t) {
        case ReminderType.task:
          return 'task';
        case ReminderType.schedule:
          return 'schedule';
        case ReminderType.custom:
        // ignore: unreachable_switch_default
        default:
          return 'custom';
      }
    }

    return {
      'userId': userId,
      'title': title,
      'description': description,
      'scheduledTime': Timestamp.fromDate(scheduledTime),
      'isCompleted': isCompleted,
      'type': typeToString(type),
    };
  }
}
