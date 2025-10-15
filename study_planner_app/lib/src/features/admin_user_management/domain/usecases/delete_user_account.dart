import 'package:dartz/dartz.dart';
import '../repositories/admin_user_repository.dart';
import '../../../../../core/errors/failure.dart';

class DeleteUserAccount {
  final AdminUserRepository repository;
  DeleteUserAccount(this.repository);

  Future<Either<Failure, void>> call(String userId) async {
    return await repository.deleteUserAccount(userId);
  }
}
