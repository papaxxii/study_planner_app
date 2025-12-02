import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../../domain/entities/admin_user_entity.dart';
import '../../domain/repositories/admin_user_repository.dart';
import '../datasources/admin_user_remote_datasource.dart';

class AdminUserRepositoryImpl implements AdminUserRepository {
  final AdminUserRemoteDataSource remoteDataSource;

  AdminUserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<AdminUser>>> getAllUsers() async {
    try {
      final models = await remoteDataSource.getAllUsers();
      return Right(models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminUser>> getUserDetails(String userId) async {
    try {
      final model = await remoteDataSource.getUserDetails(userId);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserRole(
    String userId,
    UserRole newRole,
  ) async {
    try {
      final roleString = newRole == UserRole.admin ? 'admin' : 'client';
      await remoteDataSource.updateUserRole(userId, roleString);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserAccount(String userId) async {
    try {
      await remoteDataSource.deleteUserAccount(userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
