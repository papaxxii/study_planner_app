import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../../domain/entities/task_entity.dart';
import 'task_remote_data_source.dart';

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore firestore;

  TaskRemoteDataSourceImpl({required this.firestore});

  CollectionReference get taskCollection => firestore.collection('tasks');

  @override
  Future<void> addTask(TaskModel task) async {
    await taskCollection.doc(task.id).set(task.toMap());
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await taskCollection.doc(task.id).update(task.toMap());
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await taskCollection.doc(taskId).delete();
  }

  @override
  // ignore: override_on_non_overriding_member
  Future<TaskModel> getTaskById(String taskId) async {
    final doc = await taskCollection.doc(taskId).get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('Task not found');
    }
    return TaskModel.fromFirebase(doc.data() as Map<String, dynamic>, doc.id);
  }

  @override
  Future<List<TaskModel>> getAllTasks(String userId) async {
    final snapshot = await taskCollection
        .where('userId', isEqualTo: userId)
        .get();
    if (snapshot.docs.isEmpty && kDebugMode) {
      // Provide demo tasks for display in debug mode when Firestore has no tasks for the user.
      final now = DateTime.now();
      final demo = <TaskModel>[
        TaskModel(
          id: 'demo-1',
          userId: userId,
          title: 'Welcome to Study Planner',
          description: 'Tap to edit or mark as complete',
          dueDate: DateTime(now.year, now.month, now.day, 18, 0),
          isCompleted: false,
          priority: TaskPriority.medium,
          reminderTime: DateTime.now().add(const Duration(hours: 1)),
          goalType: GoalType.daily,
          createdAt: now,
        ),
        TaskModel(
          id: 'demo-2',
          userId: userId,
          title: 'Read Chapter 4',
          description: 'Read and take notes',
          dueDate: DateTime(
            now.year,
            now.month,
            now.day,
          ).add(const Duration(days: 1, hours: 9)),
          isCompleted: false,
          priority: TaskPriority.high,
          reminderTime: DateTime.now().add(const Duration(hours: 24)),
          goalType: GoalType.weekly,
          createdAt: now.subtract(const Duration(days: 1)),
        ),
        TaskModel(
          id: 'demo-3',
          userId: userId,
          title: 'Practice Problems',
          description: 'Solve 10 problems from the problem set',
          dueDate: DateTime(
            now.year,
            now.month,
            now.day,
          ).add(const Duration(days: 7, hours: 14)),
          isCompleted: false,
          priority: TaskPriority.low,
          reminderTime: null,
          goalType: GoalType.none,
          createdAt: now.subtract(const Duration(days: 2)),
        ),
      ];
      return demo;
    }
    return snapshot.docs
        .map(
          (doc) => TaskModel.fromFirebase(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();
  }

  @override
  Future<List<TaskModel>> getTasksByDate(String userId, DateTime date) async {
    // Query tasks for user where dueDate falls on the given date.
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final snapshot = await taskCollection
        .where('userId', isEqualTo: userId)
        .where('dueDate', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('dueDate', isLessThan: Timestamp.fromDate(end))
        .get();

    if (snapshot.docs.isEmpty && kDebugMode) {
      // If no tasks found for date, provide demo tasks filtered to the requested date for display purposes.
      final allDemo = await getAllTasks(userId);
      return allDemo.where((t) {
        final d = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
        return d == start;
      }).toList();
    }

    return snapshot.docs
        .map(
          (doc) => TaskModel.fromFirebase(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();
  }
}
