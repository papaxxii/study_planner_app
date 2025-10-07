import 'package:dartz/dartz.dart';
import '../../../task&schedule_management/domain/usecases/failure.dart';
import '../repositories/goal_setting_repo.dart';

class DeleteGoal {
  final GoalRepository repository;
  DeleteGoal(this.repository);

  Future<Either<Failure, Unit>> call(String goalId) {
    return repository.deleteGoal(goalId);
  }
}