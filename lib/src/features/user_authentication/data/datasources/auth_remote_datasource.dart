import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginUser({
    required String email,
    required String password,
  });

  Future<UserModel> signupUser({
    required String email,
    required String password,
    required String name,
  });

  Future<UserModel> getUserProfile(String userId);

  Future<void> logoutUser();

  Future<void> updateUserProfile(UserModel user);
}
