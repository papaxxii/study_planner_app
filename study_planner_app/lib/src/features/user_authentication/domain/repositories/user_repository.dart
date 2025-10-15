import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../../../../../core/errors/failure.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> loginUser({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> getUserProfile(String userId);

  Future<Either<Failure, void>> logoutUser();

  Future<Either<Failure, void>> updateUserProfile(UserEntity user);
}
