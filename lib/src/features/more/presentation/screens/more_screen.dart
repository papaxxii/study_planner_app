import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../user_authentication/presentation/providers/user_auth_providers.dart';
import '../../../user_authentication/presentation/state/user_auth_state.dart';
import '../../../user_authentication/domain/entities/user_entity.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/profile'),
          ),
          ListTile(
            title: const Text('Calendar'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/calendar'),
          ),
          ListTile(
            title: const Text('Goals'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/goals'),
          ),
          ListTile(
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/settings'),
          ),
          Consumer(
            builder: (context, ref, _) {
              final authState = ref.watch(authStateProvider);
              final isAdmin =
                  authState is AuthSuccess &&
                  authState.user.role == UserRole.admin;

              if (isAdmin) {
                return ListTile(
                  title: const Text('Admin - Users'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/users'),
                );
              }

              return ListTile(
                title: const Text('Admin - Users'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Admin access required to view users'),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
