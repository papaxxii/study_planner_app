import 'package:dartz/dartz.dart';

import '../../../task&schedule_management/domain/usecases/failure.dart';
import '../entities/goal_setting.dart';
import '../repositories/goal_setting_repo.dart';

class GetGoalById {
  final GoalRepository repository;
  GetGoalById(this.repository);

  Future<Either<Failure, Goal>> call(String goalId) {
    return repository.getGoalById(goalId);
  }
}