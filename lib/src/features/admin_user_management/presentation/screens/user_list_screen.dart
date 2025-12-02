import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:study_planner_app/theme.dart';
import '../../domain/entities/admin_user_entity.dart';
import '../providers/admin_user_providers.dart';
import '../state/admin_user_state.dart';

class UserListScreen extends ConsumerWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminState = ref.watch(adminUserStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Users'), centerTitle: true),
      body: _buildBody(context, adminState),
    );
  }

  Widget _buildBody(BuildContext context, AdminUserState adminState) {
    if (adminState is AdminUserInitial) {
      return const Center(child: Text('No users found'));
    } else if (adminState is AdminUserLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (adminState is AdminUserSuccess) {
      if (adminState.users.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 64,
                color: const Color.from(
                  alpha: 1,
                  red: 0.463,
                  green: 0.031,
                  blue: 0.408,
                ).withAlpha((0.3 * 255).round()),
              ),
              const SizedBox(height: 16),
              const Text('No users found'),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: adminState.users.length,
        itemBuilder: (context, index) {
          final user = adminState.users[index];
          return _buildUserCard(context, user);
        },
      );
    } else if (adminState is AdminUserError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(adminState.message),
          ],
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildUserCard(BuildContext context, AdminUser user) {
    final roleColor = user.role == UserRole.admin ? Colors.purple : Colors.blue;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: user.isActive ? Colors.green : Colors.grey,
          child: Text(
            user.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(user.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(user.email),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: roleColor.withAlpha((0.2 * 255).round()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    user.role.toString().split('.').last.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: roleColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  user.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 10,
                    color: user.isActive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit Role')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              context.push('/users/${user.id}/edit', extra: {'user': user});
            } else if (value == 'delete') {
              // Show delete confirmation
            }
          },
        ),
        isThreeLine: true,
        onTap: () {
          // Navigate to user detail
        },
      ),
    );
  }
}
