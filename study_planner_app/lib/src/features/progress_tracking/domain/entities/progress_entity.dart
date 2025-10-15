import 'package:equatable/equatable.dart';

class ProgressEntity extends Equatable {
  final String userId;
  final int totalTasks;
  final int completedTasks;
  final double completionRate; // e.g., 0.75 = 75%
  final int currentStreakDays; // consecutive days with completed tasks
  final DateTime lastUpdated;

  const ProgressEntity({
    required this.userId,
    required this.totalTasks,
    required this.completedTasks,
    required this.completionRate,
    required this.currentStreakDays,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    userId,
    totalTasks,
    completedTasks,
    completionRate,
    currentStreakDays,
    lastUpdated,
  ];
}
