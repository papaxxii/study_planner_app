import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/progress_remote_data_source.dart';
import '../../data/datasources/progress_remote_data_source_impl.dart';
import '../../data/repository/progress_repository_impl.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/usecases/get_user_progress.dart';
import '../../domain/usecases/get_daily_progress.dart';
import '../../domain/usecases/update_progress.dart';
import '../state/progress_state.dart';
import '../state/progress_notifier.dart';

// ==============================================================================
// Firebase Dependencies (public for cross-feature use)
// ==============================================================================

/// Provider for FirebaseFirestore instance
final progressFirestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

// ==============================================================================
// Data Layer Providers (public for testing/cross-feature)
// ==============================================================================

/// Provider for ProgressRemoteDataSource
final progressRemoteDataSourceProvider = Provider<ProgressRemoteDataSource>((
  ref,
) {
  final firestore = ref.watch(progressFirestoreProvider);
  return ProgressRemoteDataSourceImpl(firestore: firestore);
});

// ==============================================================================
// Domain Layer Providers (Repository & Use Cases - public)
// ==============================================================================

/// Provider for ProgressRepository
final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final remoteDataSource = ref.watch(progressRemoteDataSourceProvider);
  return ProgressRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Provider for GetUserProgress use case
final getUserProgressProvider = Provider<GetUserProgress>((ref) {
  final repository = ref.watch(progressRepositoryProvider);
  return GetUserProgress(repository);
});

/// Provider for GetDailyProgress use case
final getDailyProgressProvider = Provider<GetDailyProgress>((ref) {
  final repository = ref.watch(progressRepositoryProvider);
  return GetDailyProgress(repository);
});

/// Provider for UpdateProgress use case
final updateProgressProvider = Provider<UpdateProgress>((ref) {
  final repository = ref.watch(progressRepositoryProvider);
  return UpdateProgress(repository);
});

// ==============================================================================
// Presentation Layer Provider (Notifier)
// ==============================================================================

/// Notifier provider that manages progress tracking state
/// Use this to access and modify progress state throughout the app
final progressStateProvider = NotifierProvider<ProgressNotifier, ProgressState>(
  () {
    return ProgressNotifier();
  },
);
