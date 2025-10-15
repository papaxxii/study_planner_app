import 'package:dartz/dartz.dart';
import '../entities/admin_user_entity.dart';
import '../repositories/admin_user_repository.dart';
import '../../../../../core/errors/failure.dart';

class UpdateUserRole {
  final AdminUserRepository repository;
  UpdateUserRole(this.repository);

  Future<Either<Failure, void>> call(String userId, UserRole newRole) async {
    return await repository.updateUserRole(userId, newRole);
  }
}
