import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:study_planner_app/theme.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/user_auth_providers.dart';
import '../state/user_auth_state.dart';

class ProfileScreen extends ConsumerWidget {
  final UserEntity? user;

  const ProfileScreen({super.key, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final authNotifier = ref.read(authStateProvider.notifier);

    final currentUser =
        user ?? (authState is AuthSuccess ? authState.user : null);

    ref.listen(authStateProvider, (previous, next) {
      if (next is AuthLogoutSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/login');
      } else if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authNotifier.logout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: currentUser.profileImageUrl != null
                  ? NetworkImage(currentUser.profileImageUrl!)
                  : null,
              child: currentUser.profileImageUrl == null
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),
            const SizedBox(height: 24),
            Text(
              currentUser.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              currentUser.email,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(
                currentUser.role.toString().split('.').last.toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.primary,
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Name'),
                      subtitle: Text(currentUser.name),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: const Text('Email'),
                      subtitle: Text(currentUser.email),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.security_outlined),
                      title: const Text('Role'),
                      subtitle: Text(
                        currentUser.role.toString().split('.').last,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to edit profile
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
