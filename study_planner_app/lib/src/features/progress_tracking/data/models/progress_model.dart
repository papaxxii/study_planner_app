import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/progress_entity.dart';

class ProgressModel extends ProgressEntity {
  const ProgressModel({
    required super.userId,
    required super.totalTasks,
    required super.completedTasks,
    required super.completionRate,
    required super.currentStreakDays,
    required super.lastUpdated,
  });

  /// Create a ProgressModel from Firestore document data
  factory ProgressModel.fromFirebase(Map<String, dynamic> data) {
    return ProgressModel(
      userId: data['userId'] ?? '',
      totalTasks: (data['totalTasks'] ?? 0) as int,
      completedTasks: (data['completedTasks'] ?? 0) as int,
      completionRate: (data['completionRate'] ?? 0).toDouble(),
      currentStreakDays: (data['currentStreakDays'] ?? 0) as int,
      lastUpdated: data['lastUpdated'] is Timestamp
          ? (data['lastUpdated'] as Timestamp).toDate()
          : DateTime.parse(
              data['lastUpdated'] ?? DateTime.now().toIso8601String(),
            ),
    );
  }

  /// Convert ProgressModel to a map suitable for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
      'completionRate': completionRate,
      'currentStreakDays': currentStreakDays,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}
