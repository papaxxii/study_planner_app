import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';
import '../../../../../core/errors/failure.dart';

class LoginUser {
  final UserRepository repository;
  LoginUser(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await repository.loginUser(email: email, password: password);
  }
}
