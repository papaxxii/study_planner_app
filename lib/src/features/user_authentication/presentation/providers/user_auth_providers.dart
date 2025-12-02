import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/auth_remote_data_source_impl.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/signup_user.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../state/user_auth_state.dart';
import '../state/user_auth_notifier.dart';

// ==============================================================================
// Firebase Dependencies
// ==============================================================================

/// Provider for FirebaseAuth instance
final firebaseAuthProvider = Provider((ref) {
  return fb.FirebaseAuth.instance;
});

/// Provider for FirebaseFirestore instance
final firestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

// ==============================================================================
// Data Layer Providers
// ==============================================================================

/// Provider for AuthRemoteDataSource
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firestoreProvider);

  return AuthRemoteDataSourceImpl(
    firebaseAuth: firebaseAuth,
    firestore: firestore,
  );
});

// ==============================================================================
// Domain Layer Providers (Repository)
// ==============================================================================

/// Provider for UserRepository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final authRemoteDataSource = ref.watch(authRemoteDataSourceProvider);

  return AuthRepositoryImpl(authRemoteDataSource);
});

// ==============================================================================
// Domain Layer Providers (Use Cases)
// ==============================================================================

/// Provider for LoginUser use case
final loginUserProvider = Provider<LoginUser>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return LoginUser(repository);
});

/// Provider for SignupUser use case
final signupUserProvider = Provider<SignupUser>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return SignupUser(repository);
});

/// Provider for LogoutUser use case
final logoutUserProvider = Provider<LogoutUser>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return LogoutUser(repository);
});

/// Provider for GetUserProfile use case
final getUserProfileProvider = Provider<GetUserProfile>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUserProfile(repository);
});

/// Provider for UpdateUserProfile use case
final updateUserProfileProvider = Provider<UpdateUserProfile>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UpdateUserProfile(repository);
});

// ==============================================================================
// Presentation Layer Providers (StateNotifier)
// ==============================================================================

/// Provider for UserAuthNotifier with all use cases injected
/// Use this to access and modify authentication state throughout the app
final authStateProvider = NotifierProvider<UserAuthNotifier, AuthState>(
  UserAuthNotifier.new,
);

// Usage notes:
// - Inside ConsumerWidgets or providers, use:
//   final authState = ref.watch(authStateProvider);
//   ref.read(authStateProvider.notifier).login(email: '...', password: '...');
// - Listen to auth state changes with:
//   ref.listen<AuthState>(authStateProvider, (previous, next) { ... });
