import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_user_entity.dart';

abstract class AdminUserState extends Equatable {
  const AdminUserState();

  @override
  List<Object?> get props => [];
}

class AdminUserInitial extends AdminUserState {
  const AdminUserInitial();
}

class AdminUserLoading extends AdminUserState {
  const AdminUserLoading();
}

class AdminUserSuccess extends AdminUserState {
  final List<AdminUser> users;

  const AdminUserSuccess(this.users);

  @override
  List<Object?> get props => [users];
}

class AdminUserDetailSuccess extends AdminUserState {
  final AdminUser user;

  const AdminUserDetailSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AdminUserError extends AdminUserState {
  final String message;

  const AdminUserError(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminUserUpdateRoleSuccess extends AdminUserState {
  final String message;

  const AdminUserUpdateRoleSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminUserDeleteSuccess extends AdminUserState {
  final String userId;

  const AdminUserDeleteSuccess(this.userId);

  @override
  List<Object?> get props => [userId];
}
