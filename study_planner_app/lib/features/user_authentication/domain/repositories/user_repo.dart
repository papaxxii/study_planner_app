import 'package:dartz/dartz.dart';

import '../../../task&schedule_management/domain/usecases/failure.dart' show Failure;
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> signup(User user);
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, User?>> getCurrentUser();
}
