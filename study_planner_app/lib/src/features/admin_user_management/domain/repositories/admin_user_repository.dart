import 'package:dartz/dartz.dart';
import '../entities/admin_user_entity.dart';
import '../../../../../core/errors/failure.dart';

abstract class AdminUserRepository {
  /// Fetch all registered users in the system
  Future<Either<Failure, List<AdminUserEntity>>> getAllUsers();

  /// Fetch a specific user’s details
  Future<Either<Failure, AdminUserEntity>> getUserDetails(String userId);

  /// Update a user’s role (e.g., client → admin)
  Future<Either<Failure, void>> updateUserRole(String userId, UserRole newRole);

  /// Delete a user account permanently (admin-only action)
  Future<Either<Failure, void>> deleteUserAccount(String userId);
}
