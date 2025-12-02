import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';
import '../../../../../core/errors/failure.dart';

/// Sign up a new user with email, password, and name
class SignupUser {
  final UserRepository repository;

  SignupUser(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String name,
  }) {
    return repository.signupUser(email: email, password: password, name: name);
  }
}
