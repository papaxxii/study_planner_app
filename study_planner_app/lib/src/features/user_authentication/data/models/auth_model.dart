class UserModel {
  final String id;
  final String email;
  final String username;
  final String passwordHash;

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.passwordHash,
  });

  factory UserModel.fromFirebase(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      passwordHash: data['passwordHash'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'username': username, 'passwordHash': passwordHash};
  }
}
