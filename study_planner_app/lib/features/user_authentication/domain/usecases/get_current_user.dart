import 'package:dartz/dartz.dart';
import '../../../task&schedule_management/domain/usecases/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repo.dart';

class GetCurrentUser {
  final AuthRepository repository;
  GetCurrentUser(this.repository);

  Future<Either<Failure, User?>> call() {
    return repository.getCurrentUser();
  }
}
