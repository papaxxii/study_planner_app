import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/admin_user_entity.dart';
import '../../domain/usecases/delete_user_account.dart';
import '../../domain/usecases/get_all_user.dart';
import '../../domain/usecases/get_user_details.dart';
import '../../domain/usecases/update_user_role.dart';
import '../providers/admin_user_providers.dart'
    show adminUserRepositoryProvider;
import 'admin_user_state.dart';

// Private providers for dependency injection
final _getAllUsersProvider = Provider<GetAllUsers>((ref) {
  final repository = ref.watch(adminUserRepositoryProvider);
  return GetAllUsers(repository);
});

final _getUserDetailsProvider = Provider<GetUserDetails>((ref) {
  final repository = ref.watch(adminUserRepositoryProvider);
  return GetUserDetails(repository);
});

final _updateUserRoleProvider = Provider<UpdateUserRole>((ref) {
  final repository = ref.watch(adminUserRepositoryProvider);
  return UpdateUserRole(repository);
});

final _deleteUserAccountProvider = Provider<DeleteUserAccount>((ref) {
  final repository = ref.watch(adminUserRepositoryProvider);
  return DeleteUserAccount(repository);
});

class AdminUserNotifier extends Notifier<AdminUserState> {
  late final GetAllUsers _getAllUsers;
  late final GetUserDetails _getUserDetails;
  late final UpdateUserRole _updateUserRole;
  late final DeleteUserAccount _deleteUserAccount;

  @override
  AdminUserState build() {
    _getAllUsers = ref.watch(_getAllUsersProvider);
    _getUserDetails = ref.watch(_getUserDetailsProvider);
    _updateUserRole = ref.watch(_updateUserRoleProvider);
    _deleteUserAccount = ref.watch(_deleteUserAccountProvider);
    return const AdminUserInitial();
  }

  Future<void> fetchAllUsers() async {
    state = const AdminUserLoading();
    final result = await _getAllUsers();
    result.fold(
      (failure) => state = AdminUserError(failure.message),
      (users) => state = AdminUserSuccess(users),
    );
  }

  Future<void> fetchUserDetails(String userId) async {
    state = const AdminUserLoading();
    final result = await _getUserDetails(userId);
    result.fold(
      (failure) => state = AdminUserError(failure.message),
      (user) => state = AdminUserDetailSuccess(user),
    );
  }

  Future<void> updateUserRole(String userId, UserRole newRole) async {
    state = const AdminUserLoading();
    final result = await _updateUserRole(userId, newRole);
    result.fold(
      (failure) => state = AdminUserError(failure.message),
      (_) =>
          state = AdminUserUpdateRoleSuccess('User role updated successfully'),
    );
  }

  Future<void> deleteUserAccount(String userId) async {
    state = const AdminUserLoading();
    final result = await _deleteUserAccount(userId);
    result.fold(
      (failure) => state = AdminUserError(failure.message),
      (_) => state = AdminUserDeleteSuccess(userId),
    );
  }

  void resetState() {
    state = const AdminUserInitial();
  }
}

class UpdateUserRoleParams {
  UpdateUserRoleParams(String userId, UserRole newRole);
}
