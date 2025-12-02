import 'package:equatable/equatable.dart';

enum ReminderType { task, schedule, custom }

class ReminderEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final DateTime scheduledTime;
  final bool isCompleted;
  final ReminderType type;

  const ReminderEntity({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.scheduledTime,
    required this.isCompleted,
    required this.type,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    description,
    scheduledTime,
    isCompleted,
    type,
  ];
}
