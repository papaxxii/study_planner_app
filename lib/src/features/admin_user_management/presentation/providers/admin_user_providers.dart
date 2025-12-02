import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/admin_user_remote_datasource.dart';
import '../../data/datasources/admin_user_remote_data_source_impl.dart';
import '../../data/repository/admin_user_repository_impl.dart';
import '../../domain/repositories/admin_user_repository.dart';
import '../../domain/usecases/delete_user_account.dart';
import '../../domain/usecases/get_all_user.dart';
import '../../domain/usecases/get_user_details.dart';
import '../../domain/usecases/update_user_role.dart';
import '../../presentation/state/admin_user_notifier.dart';
import '../../presentation/state/admin_user_state.dart';

// Firebase providers
final adminFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Remote data source provider
final adminRemoteDataSourceProvider = Provider<AdminUserRemoteDataSource>((
  ref,
) {
  final firestore = ref.watch(adminFirestoreProvider);
  return AdminUserRemoteDataSourceImpl(firestore: firestore);
});

// Repository provider
final adminUserRepositoryProvider = Provider<AdminUserRepository>((ref) {
  final remoteDataSource = ref.watch(adminRemoteDataSourceProvider);
  return AdminUserRepositoryImpl(remoteDataSource);
});

// Use case providers
final getAllUsersProvider = Provider<GetAllUsers>((ref) {
  final repository = ref.watch(adminUserRepositoryProvider);
  return GetAllUsers(repository);
});

final getUserDetailsProvider = Provider<GetUserDetails>((ref) {
  final repository = ref.watch(adminUserRepositoryProvider);
  return GetUserDetails(repository);
});

final updateUserRoleProvider = Provider<UpdateUserRole>((ref) {
  final repository = ref.watch(adminUserRepositoryProvider);
  return UpdateUserRole(repository);
});

final deleteUserAccountProvider = Provider<DeleteUserAccount>((ref) {
  final repository = ref.watch(adminUserRepositoryProvider);
  return DeleteUserAccount(repository);
});

// State notifier provider
final adminUserStateProvider =
    NotifierProvider<AdminUserNotifier, AdminUserState>(() {
      return AdminUserNotifier();
    });
