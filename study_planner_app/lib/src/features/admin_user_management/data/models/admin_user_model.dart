import '../../domain/entities/admin_user_entity.dart';

class AdminUserModel extends AdminUser {
  const AdminUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.isActive,
    required super.createdAt,
  });

  static UserRole _parseRole(Object? value) {
    if (value is String) {
      switch (value) {
        case 'admin':
          return UserRole.admin;
        case 'client':
        default:
          return UserRole.client;
      }
    }
    return UserRole.client;
  }

  factory AdminUserModel.fromFirebase(Map<String, dynamic> data, String id) {
    return AdminUserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: _parseRole(data['role']),
      isActive: data['isActive'] ?? true,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role == UserRole.admin ? 'admin' : 'client',
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
