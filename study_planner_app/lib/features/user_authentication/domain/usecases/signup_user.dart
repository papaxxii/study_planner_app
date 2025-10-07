import 'package:dartz/dartz.dart';
import '../../../task&schedule_management/domain/usecases/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repo.dart';

class SignupUser {
  final AuthRepository repository;
  SignupUser(this.repository);

  Future<Either<Failure, User>> call(User user) {
    return repository.signup(user);
  }
}
