import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';
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
    return TaskModel.fromFirebase(doc.data() as Map<String, dynamic>, doc.id);
  }

  @override
  Future<List<TaskModel>> getAllTasks(String userId) async {
    final snapshot = await taskCollection
        .where('userId', isEqualTo: userId)
        .get();
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
