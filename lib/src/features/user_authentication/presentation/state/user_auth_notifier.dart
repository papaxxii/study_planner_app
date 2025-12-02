import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/signup_user.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../providers/user_auth_providers.dart';
import 'user_auth_state.dart';

/// Notifier for managing user authentication state
class UserAuthNotifier extends Notifier<AuthState> {
  // Use cases - will be lazy loaded from ref
  late LoginUser _loginUser;
  late SignupUser _signupUser;
  late LogoutUser _logoutUser;
  late GetUserProfile _getUserProfile;
  late UpdateUserProfile _updateUserProfile;

  @override
  AuthState build() {
    // Lazy load use cases from providers when notifier is first accessed
    _loginUser = ref.watch(loginUserProvider);
    _signupUser = ref.watch(signupUserProvider);
    _logoutUser = ref.watch(logoutUserProvider);
    _getUserProfile = ref.watch(getUserProfileProvider);
    _updateUserProfile = ref.watch(updateUserProfileProvider);
    return const AuthInitial();
  }

  /// Login with email and password
  Future<void> login({required String email, required String password}) async {
    state = const AuthLoading();
    final result = await _loginUser(email: email, password: password);

    result.fold(
      (failure) => state = AuthError(failure.message),
      (user) => state = AuthSuccess(user),
    );
  }

  /// Sign up a new user with email, password, and name
  Future<void> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AuthLoading();
    final result = await _signupUser(
      email: email,
      password: password,
      name: name,
    );

    result.fold(
      (failure) => state = AuthError(failure.message),
      (user) => state = AuthSuccess(user),
    );
  }

  /// Logout current user
  Future<void> logout() async {
    state = const AuthLoading();
    final result = await _logoutUser();

    result.fold(
      (failure) => state = AuthError(failure.message),
      (_) => state = const AuthLogoutSuccess(),
    );
  }

  /// Fetch user profile by user ID
  Future<void> fetchUserProfile(String userId) async {
    state = const AuthLoading();
    final result = await _getUserProfile(userId);

    result.fold(
      (failure) => state = AuthError(failure.message),
      (user) => state = AuthSuccess(user),
    );
  }

  /// Update user profile
  Future<void> updateProfile(UserEntity user) async {
    state = const AuthLoading();
    final result = await _updateUserProfile(user);

    result.fold((failure) => state = AuthError(failure.message), (_) {
      // After successful update, fetch the latest profile
      if (state is AuthSuccess) {
        final currentUser = (state as AuthSuccess).user;
        state = AuthSuccess(currentUser);
      }
    });
  }

  /// Reset to initial state
  void resetState() {
    state = const AuthInitial();
  }
}
