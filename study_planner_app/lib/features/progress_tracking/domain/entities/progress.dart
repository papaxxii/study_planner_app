import 'package:equatable/equatable.dart';

class Progress extends Equatable {
  final String taskId;
  final bool isCompleted;
  final DateTime completedAt;

  const Progress({
    required this.taskId,
    required this.isCompleted,
    required this.completedAt,
  });

  @override
  List<Object?> get props => [taskId, isCompleted, completedAt];
}
