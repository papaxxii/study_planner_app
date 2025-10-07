
import 'package:dartz/dartz.dart';
import '../../../task&schedule_management/domain/usecases/failure.dart';
import '../entities/goal_setting.dart';
import '../repositories/goal_setting_repo.dart';

class UpdateGoal {
  final GoalRepository repository;
  UpdateGoal(this.repository);

  Future<Either<Failure, Unit>> call(Goal goal) {
    return repository.updateGoal(goal);
  }
}