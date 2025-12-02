import 'package:equatable/equatable.dart';
import '../../domain/entities/progress_entity.dart';

/// Base class for progress tracking state
abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

/// Initial state when no progress operation has been performed
class ProgressInitial extends ProgressState {
  const ProgressInitial();
}

/// Loading state during async progress operations
class ProgressLoading extends ProgressState {
  const ProgressLoading();
}

/// Success state after fetching or updating progress
class ProgressSuccess extends ProgressState {
  final ProgressEntity progress;

  const ProgressSuccess(this.progress);

  @override
  List<Object?> get props => [progress];
}

/// Error state when a progress operation fails
class ProgressError extends ProgressState {
  final String message;

  const ProgressError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State for successful update operations
class ProgressUpdateSuccess extends ProgressState {
  final String message;

  const ProgressUpdateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
