import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:study_planner_app/theme.dart';
import '../../domain/entities/admin_user_entity.dart';
import '../providers/admin_user_providers.dart';

class EditUserRoleScreen extends ConsumerWidget {
  final AdminUser user;

  const EditUserRoleScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormBuilderState>();
    final adminNotifier = ref.read(adminUserStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit User Role')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage User Role',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        child: Text(user.name[0].toUpperCase()),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FormBuilderDropdown<UserRole>(
                name: 'role',
                initialValue: user.role,
                decoration: const InputDecoration(
                  labelText: 'User Role',
                  prefixIcon: Icon(Icons.security_outlined),
                ),
                items: UserRole.values
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(
                          role.toString().split('.').last.toUpperCase(),
                        ),
                      ),
                    )
                    .toList(),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              FormBuilderCheckbox(
                name: 'isActive',
                initialValue: user.isActive,
                title: const Text('Active'),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.saveAndValidate() ?? false) {
                      final newRole =
                          formKey.currentState?.value['role'] as UserRole;
                      adminNotifier.updateUserRole(user.id, newRole);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Update Role'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete User'),
                        content: Text(
                          'Are you sure you want to delete ${user.name}?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              adminNotifier.deleteUserAccount(user.id);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Delete User'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
