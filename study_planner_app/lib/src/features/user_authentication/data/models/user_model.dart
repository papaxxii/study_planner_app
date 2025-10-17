import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.profileImageUrl,
  });

  factory UserModel.fromFirebase(Map<String, dynamic> data, String id) {
    UserRole parseRole(Object? value) {
      if (value is String) {
        return value == 'admin' ? UserRole.admin : UserRole.client;
      }
      return UserRole.client;
    }

    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: parseRole(data['role']),
      profileImageUrl: data['profileImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role == UserRole.admin ? 'admin' : 'client',
      'profileImageUrl': profileImageUrl,
    };
  }
}
