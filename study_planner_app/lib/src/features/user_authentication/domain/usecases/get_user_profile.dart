import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';


class GetUserProfile {
  final UserRepository repository;
  GetUserProfile(this.repository);

  Future<Either<Failure, UserEntity>> call(String userId) async {
    return await repository.getUserProfile(userId);
  }
}
