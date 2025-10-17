import 'package:dartz/dartz.dart';
import '../entities/admin_user_entity.dart';
import '../repositories/admin_user_repository.dart';
import '../../../../../core/errors/failure.dart';

class GetAllUsers {
  final AdminUserRepository repository;
  GetAllUsers(this.repository);

  Future<Either<Failure, List<AdminUser>>> call() async {
    return await repository.getAllUsers();
  }
}
