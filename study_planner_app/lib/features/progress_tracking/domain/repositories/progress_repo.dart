import 'package:dartz/dartz.dart';

import '../../../task&schedule_management/domain/usecases/failure.dart';
import '../entities/progress.dart';

abstract class ProgressRepository {
  Future<Either<Failure, Unit>> markAsComplete(String taskId);
  Future<Either<Failure, Unit>> resetProgress(String taskId);
  Future<Either<Failure, List<Progress>>> getProgressHistory();
}
