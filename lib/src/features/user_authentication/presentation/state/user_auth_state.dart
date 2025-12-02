import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

/// Base class for auth state
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when no auth operation has been performed
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state during async auth operations
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Success state after a successful auth operation
class AuthSuccess extends AuthState {
  final UserEntity user;

  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

/// Error state when an auth operation fails
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Logout success state
class AuthLogoutSuccess extends AuthState {
  const AuthLogoutSuccess();
}
