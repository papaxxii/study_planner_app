import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.description,
    required super.dueDate,
    required super.isCompleted,
    required super.priority,
    required super.createdAt,
  });

  factory TaskModel.fromFirebase(Map<String, dynamic> data, String id) {
    TaskPriority parsePriority(Object? val) {
      if (val is String) {
        switch (val) {
          case 'low':
            return TaskPriority.low;
          case 'medium':
            return TaskPriority.medium;
          case 'high':
            return TaskPriority.high;
        }
      }
      return TaskPriority.medium;
    }

    return TaskModel(
      id: id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      dueDate: data['dueDate'] is Timestamp
          ? (data['dueDate'] as Timestamp).toDate()
          : DateTime.parse(data['dueDate'] ?? DateTime.now().toIso8601String()),
      isCompleted: data['isCompleted'] ?? false,
      priority: parsePriority(data['priority']),
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.parse(
              data['createdAt'] ?? DateTime.now().toIso8601String(),
            ),
    );
  }

  Map<String, dynamic> toMap() {
    String priorityToString(TaskPriority p) {
      switch (p) {
        case TaskPriority.low:
          return 'low';
        case TaskPriority.medium:
          return 'medium';
        case TaskPriority.high:
          return 'high';
      }
    }

    return {
      'userId': userId,
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'isCompleted': isCompleted,
      'priority': priorityToString(priority),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
