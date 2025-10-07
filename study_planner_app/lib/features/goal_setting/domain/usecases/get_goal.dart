
import 'package:dartz/dartz.dart';
import '../../../task&schedule_management/domain/usecases/failure.dart';
import '../entities/goal_setting.dart';
import '../repositories/goal_setting_repo.dart';

class GetGoals {
  final GoalRepository repository;
  GetGoals(this.repository);

  Future<Either<Failure, List<Goal>>> call() {
    return repository.getGoals();
  }
}