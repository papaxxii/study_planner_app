import 'package:equatable/equatable.dart';

enum TaskPriority { low, medium, high }

enum GoalType { none, daily, weekly, exam }

class TaskEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final TaskPriority priority;
  // optional reminder time for the task (may be null)
  final DateTime? reminderTime;
  // optional goal type the task contributes towards
  final GoalType goalType;
  final DateTime createdAt;

  const TaskEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
    required this.priority,
    this.reminderTime,
    this.goalType = GoalType.none,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    description,
    dueDate,
    isCompleted,
    priority,
    createdAt,
  ];
}
