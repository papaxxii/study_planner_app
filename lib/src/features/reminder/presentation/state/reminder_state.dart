import 'package:equatable/equatable.dart';
import '../../domain/entities/reminder_entity.dart';

/// Base class for reminder state
abstract class ReminderState extends Equatable {
  const ReminderState();

  @override
  List<Object?> get props => [];
}

/// Initial state when no reminder operation has been performed
class ReminderInitial extends ReminderState {
  const ReminderInitial();
}

/// Loading state during async reminder operations
class ReminderLoading extends ReminderState {
  const ReminderLoading();
}

/// Success state after fetching reminders
class ReminderSuccess extends ReminderState {
  final List<ReminderEntity> reminders;

  const ReminderSuccess(this.reminders);

  @override
  List<Object?> get props => [reminders];
}

/// Error state when a reminder operation fails
class ReminderError extends ReminderState {
  final String message;

  const ReminderError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Success state after creating a reminder
class ReminderCreateSuccess extends ReminderState {
  final String message;

  const ReminderCreateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Success state after deleting a reminder
class ReminderDeleteSuccess extends ReminderState {
  final String reminderId;

  const ReminderDeleteSuccess(this.reminderId);

  @override
  List<Object?> get props => [reminderId];
}

/// Success state after sending notification
class NotificationSentSuccess extends ReminderState {
  final String message;

  const NotificationSentSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
