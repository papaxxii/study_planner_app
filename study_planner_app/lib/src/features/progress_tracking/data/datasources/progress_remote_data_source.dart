import '../models/progress_model.dart';

abstract class ProgressRemoteDataSource {
  /// Get overall progress of the user
  Future<ProgressModel> getUserProgress(String userId);

  /// Get progress for a specific day
  Future<ProgressModel> getDailyProgress(String userId, DateTime date);

  /// Update or create progress for a user
  Future<void> updateProgress(String userId, ProgressModel progress);

  /// Add progress document (if needed)
  Future<void> addProgress(ProgressModel progress);

  /// Delete a progress document by id
  Future<void> deleteProgress(String progressId);
}
