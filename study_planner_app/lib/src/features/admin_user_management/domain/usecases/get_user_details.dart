import 'package:dartz/dartz.dart';
import '../entities/admin_user_entity.dart';
import '../repositories/admin_user_repository.dart';
import '../../../../../core/errors/failure.dart';

class GetUserDetails {
  final AdminUserRepository repository;
  GetUserDetails(this.repository);

  Future<Either<Failure, AdminUserEntity>> call(String userId) async {
    return await repository.getUserDetails(userId);
  }
}
