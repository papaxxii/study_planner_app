import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String name;
  final DateTime dueDate;
  final int priority; // e.g., 1 = High, 2 = Medium, 3 = Low
  final bool isCompleted;

  const Task({
    required this.id,
    required this.name,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [id, name, dueDate, priority, isCompleted];
}





