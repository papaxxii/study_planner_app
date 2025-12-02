import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

/// Base class for task state
abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

/// Initial state when no task operation has been performed
class TaskInitial extends TaskState {
  const TaskInitial();
}

/// Loading state during async task operations
class TaskLoading extends TaskState {
  const TaskLoading();
}

/// Success state after fetching tasks
class TaskSuccess extends TaskState {
  final List<TaskEntity> tasks;

  const TaskSuccess(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

/// Error state when a task operation fails
class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Success state after adding a task
class TaskAddSuccess extends TaskState {
  final String message;

  const TaskAddSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Success state after updating a task
class TaskUpdateSuccess extends TaskState {
  final String message;

  const TaskUpdateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Success state after deleting a task
class TaskDeleteSuccess extends TaskState {
  final String taskId;

  const TaskDeleteSuccess(this.taskId);

  @override
  List<Object?> get props => [taskId];
}
