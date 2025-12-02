import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';
import '../../../../../core/errors/failure.dart';

class UpdateUserProfile {
  final UserRepository repository;
  UpdateUserProfile(this.repository);

  Future<Either<Failure, void>> call(UserEntity user) async {
    return await repository.updateUserProfile(user);
  }
}
