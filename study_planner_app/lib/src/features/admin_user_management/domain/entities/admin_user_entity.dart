import 'package:equatable/equatable.dart';

enum UserRole { client, admin }

class AdminUserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;

  const AdminUserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, role, isActive, createdAt];
}
