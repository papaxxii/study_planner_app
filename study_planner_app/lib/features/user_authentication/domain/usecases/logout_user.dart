import 'package:dartz/dartz.dart';
import '../../../task&schedule_management/domain/usecases/failure.dart';
import '../repositories/user_repo.dart';

class LogoutUser {
  final AuthRepository repository;
  LogoutUser(this.repository);

  Future<Either<Failure, Unit>> call() {
    return repository.logout();
  }
}
