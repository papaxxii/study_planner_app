import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../user_authentication/presentation/state/user_auth_state.dart';
import '../../../user_authentication/presentation/providers/user_auth_providers.dart';
import '../state/task_notifier.dart';
import '../../data/models/task_model.dart';
import '../../../task&schedule_management/domain/entities/task_entity.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddTaskScreen extends ConsumerWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormBuilderState>();
    final authState = ref.watch(authStateProvider);
    final taskNotifier = ref.read(taskStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create a New Task',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              FormBuilderTextField(
                name: 'title',
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  hintText: 'Enter task title',
                  prefixIcon: const Icon(Icons.edit_outlined),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                ]),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'description',
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter task description',
                  prefixIcon: const Icon(Icons.description_outlined),
                ),
                maxLines: 3,
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              FormBuilderDateTimePicker(
                name: 'dueDate',
                decoration: const InputDecoration(
                  labelText: 'Due Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              FormBuilderDateTimePicker(
                name: 'reminderTime',
                decoration: const InputDecoration(
                  labelText: 'Reminder Time',
                  prefixIcon: Icon(Icons.alarm),
                ),
                inputType: InputType.both,
              ),
              const SizedBox(height: 16),
              FormBuilderDropdown<String>(
                name: 'goalType',
                decoration: const InputDecoration(
                  labelText: 'Goal (optional)',
                  prefixIcon: Icon(Icons.emoji_events_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: 'none', child: Text('None')),
                  DropdownMenuItem(value: 'daily', child: Text('Daily')),
                  DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                  DropdownMenuItem(value: 'exam', child: Text('Exam Prep')),
                ],
              ),
              const SizedBox(height: 16),
              FormBuilderDropdown<String>(
                name: 'priority',
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: 'low', child: Text('Low')),
                  DropdownMenuItem(value: 'medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'high', child: Text('High')),
                ],
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.saveAndValidate() ?? false) {
                      final values = formKey.currentState!.value;
                      final title = values['title'] as String;
                      final description = values['description'] as String;
                      final dueDate = values['dueDate'] as DateTime;
                      final reminder = values['reminderTime'] as DateTime?;
                      final priorityStr = values['priority'] as String;
                      final goalStr = values['goalType'] as String? ?? 'none';

                      TaskPriority parsePriority(String s) {
                        switch (s) {
                          case 'low':
                            return TaskPriority.low;
                          case 'high':
                            return TaskPriority.high;
                          default:
                            return TaskPriority.medium;
                        }
                      }

                      GoalType parseGoal(String s) {
                        switch (s) {
                          case 'daily':
                            return GoalType.daily;
                          case 'weekly':
                            return GoalType.weekly;
                          case 'exam':
                            return GoalType.exam;
                          default:
                            return GoalType.none;
                        }
                      }

                      final userId = authState is AuthSuccess
                          ? authState.user.id
                          : null;

                      if (userId == null || userId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'You must be signed in to create tasks.',
                            ),
                          ),
                        );
                        return;
                      }
                      final id =
                          'task_${DateTime.now().millisecondsSinceEpoch}';

                      final newTask = TaskModel(
                        id: id,
                        userId: userId,
                        title: title,
                        description: description,
                        dueDate: dueDate,
                        isCompleted: false,
                        priority: parsePriority(priorityStr),
                        reminderTime: reminder,
                        goalType: parseGoal(goalStr),
                        createdAt: DateTime.now(),
                      );

                      await taskNotifier.addTask(newTask);

                      // Refresh task list so dashboard/calendar update immediately
                      await ref
                          .read(taskStateProvider.notifier)
                          .fetchAllTasks(userId);

                      // TODO: schedule local notification for reminderTime / overdue nudges

                      if (context.mounted) {
                        context.pop();
                      }
                    }
                  },
                  child: const Text('Create Task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
