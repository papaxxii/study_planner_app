import 'package:dartz/dartz.dart';
import '../../../task&schedule_management/domain/usecases/failure.dart';
import '../entities/goal_setting.dart';
import '../repositories/goal_setting_repo.dart';

class AddGoal {
  final GoalRepository repository;
  AddGoal(this.repository);

  Future<Either<Failure, Unit>> call(Goal goal) {
    return repository.addGoal(goal);
  }
}