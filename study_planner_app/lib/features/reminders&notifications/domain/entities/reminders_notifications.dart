import 'package:equatable/equatable.dart';

class Reminder extends Equatable {
  final String id;
  final String taskId;
  final DateTime remindAt;

  const Reminder({
    required this.id,
    required this.taskId,
    required this.remindAt,
  });

  @override
  List<Object?> get props => [id, taskId, remindAt];
}
