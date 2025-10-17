import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginUser({
    required String email,
    required String password,
  });

  Future<UserModel> getUserProfile(String userId);

  Future<void> logoutUser();

  Future<void> updateUserProfile(UserModel user);
}
