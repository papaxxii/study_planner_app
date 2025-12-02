import 'package:equatable/equatable.dart';

enum UserRole { client, admin }

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? profileImageUrl;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [id, name, email, role, profileImageUrl];
}
