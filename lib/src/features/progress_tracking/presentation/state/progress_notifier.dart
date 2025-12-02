import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/progress_entity.dart';
import '../../domain/usecases/get_user_progress.dart';
import '../../domain/usecases/get_daily_progress.dart';
import '../../domain/usecases/update_progress.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../data/datasources/progress_remote_data_source.dart';
import '../../data/datasources/progress_remote_data_source_impl.dart';
import '../../data/repository/progress_repository_impl.dart';
import 'progress_state.dart';

// ==============================================================================
// Private Providers
// ==============================================================================

final _progressFirestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

final _progressRemoteDataSourceProvider = Provider<ProgressRemoteDataSource>((
  ref,
) {
  final firestore = ref.watch(_progressFirestoreProvider);
  return ProgressRemoteDataSourceImpl(firestore: firestore);
});

final _progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final remoteDataSource = ref.watch(_progressRemoteDataSourceProvider);
  return ProgressRepositoryImpl(remoteDataSource: remoteDataSource);
});

final _getUserProgressProvider = Provider<GetUserProgress>((ref) {
  final repository = ref.watch(_progressRepositoryProvider);
  return GetUserProgress(repository);
});

final _getDailyProgressProvider = Provider<GetDailyProgress>((ref) {
  final repository = ref.watch(_progressRepositoryProvider);
  return GetDailyProgress(repository);
});

final _updateProgressProvider = Provider<UpdateProgress>((ref) {
  final repository = ref.watch(_progressRepositoryProvider);
  return UpdateProgress(repository);
});

// ==============================================================================
// Notifier
// ==============================================================================

/// Notifier for managing progress tracking state
class ProgressNotifier extends Notifier<ProgressState> {
  // Use cases - initialized lazily when needed
  late final GetUserProgress _getUserProgress;
  late final GetDailyProgress _getDailyProgress;
  late final UpdateProgress _updateProgress;

  @override
  ProgressState build() {
    // Initialize use cases from providers
    _getUserProgress = ref.watch(_getUserProgressProvider);
    _getDailyProgress = ref.watch(_getDailyProgressProvider);
    _updateProgress = ref.watch(_updateProgressProvider);

    return const ProgressInitial();
  }

  /// Fetch overall user progress
  Future<void> fetchUserProgress(String userId) async {
    state = const ProgressLoading();
    final result = await _getUserProgress(userId);

    result.fold(
      (failure) => state = ProgressError(failure.message),
      (progress) => state = ProgressSuccess(progress),
    );
  }

  /// Fetch progress for a specific day
  Future<void> fetchDailyProgress(String userId, DateTime date) async {
    state = const ProgressLoading();
    final result = await _getDailyProgress(userId, date);

    result.fold(
      (failure) => state = ProgressError(failure.message),
      (progress) => state = ProgressSuccess(progress),
    );
  }

  /// Update user progress
  Future<void> update(String userId, ProgressEntity progress) async {
    state = const ProgressLoading();
    final result = await _updateProgress(userId, progress);

    result.fold(
      (failure) => state = ProgressError(failure.message),
      (_) =>
          state = const ProgressUpdateSuccess('Progress updated successfully'),
    );
  }

  /// Reset to initial state
  void resetState() {
    state = const ProgressInitial();
  }
}
