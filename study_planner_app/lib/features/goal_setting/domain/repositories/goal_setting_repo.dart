import 'package:dartz/dartz.dart';
import 'package:study_planner_app/features/task&schedule_management/domain/usecases/failure.dart' show Failure;

import '../entities/goal_setting.dart';

abstract class GoalRepository {
  Future<Either<Failure, Unit>> addGoal(Goal goal);
  Future<Either<Failure, Unit>> updateGoal(Goal goal);
  Future<Either<Failure, Unit>> deleteGoal(String goalId);
  Future<Either<Failure, List<Goal>>> getGoals();
  Future<Either<Failure, Goal>> getGoalById(String goalId);
}
