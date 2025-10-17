import '../models/admin_user_model.dart';

abstract class AdminUserRemoteDataSource {
  /// Get all users
  Future<List<AdminUserModel>> getAllUsers();

  /// Get a specific user
  Future<AdminUserModel> getUserDetails(String userId);

  /// Update a user's role
  Future<void> updateUserRole(String userId, String role);

  /// Delete a user
  Future<void> deleteUserAccount(String userId);
}
