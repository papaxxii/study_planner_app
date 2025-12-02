import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:study_planner_app/theme.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/task_providers.dart';
import '../state/task_state.dart';
import '../../data/models/task_model.dart';
import '../../../progress_tracking/presentation/providers/progress_providers.dart';
import '../../../progress_tracking/domain/entities/progress_entity.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks'), centerTitle: true),
      body: _buildBody(context, taskState),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('add_task');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, TaskState taskState) {
    if (taskState is TaskInitial) {
      return const Center(child: Text('No tasks yet'));
    } else if (taskState is TaskLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (taskState is TaskSuccess) {
      if (taskState.tasks.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.task_outlined,
                size: 64,
                color: AppColors.primary.withAlpha((0.3 * 255).round()),
              ),
              const SizedBox(height: 16),
              const Text('No tasks yet'),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: taskState.tasks.length,
        itemBuilder: (context, index) {
          final task = taskState.tasks[index];
          return Consumer(
            builder: (context, ref, _) {
              return _buildTaskCard(context, ref, task);
            },
          );
        },
      );
    } else if (taskState is TaskError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(taskState.message),
          ],
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildTaskCard(BuildContext context, WidgetRef ref, TaskEntity task) {
    final priorityColor = _getPriorityColor(task.priority);
    final notifier = ref.read(taskStateProvider.notifier);
    final dateFormatter = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) async {
            // Toggle completion and update task
            final updated = TaskModel(
              id: task.id,
              userId: task.userId,
              title: task.title,
              description: task.description,
              dueDate: task.dueDate,
              isCompleted: value ?? false,
              priority: task.priority,
              reminderTime: (task as dynamic).reminderTime,
              goalType: (task as dynamic).goalType,
              createdAt: task.createdAt,
            );

            await notifier.updateTask(updated);

            // Re-fetch tasks to compute new totals
            await ref
                .read(taskStateProvider.notifier)
                .fetchAllTasks(updated.userId);

            // Compute totals from refreshed task state
            final ts = ref.read(taskStateProvider);
            int total = 0;
            int completed = 0;
            if (ts is TaskSuccess) {
              total = ts.tasks.length;
              completed = ts.tasks.where((t) => t.isCompleted).length;
            }

            // Fetch existing progress (if any)
            final progressResult = await ref.read(getUserProgressProvider)(
              updated.userId,
            );
            ProgressEntity currentProgress = ProgressEntity(
              userId: updated.userId,
              totalTasks: total,
              completedTasks: completed,
              completionRate: total == 0 ? 0.0 : (completed / total),
              currentStreakDays: 0,
              lastUpdated: DateTime.now(),
            );

            progressResult.fold(
              (failure) {
                // If fetching progress failed, we'll create/update using computed totals
              },
              (prog) {
                currentProgress = ProgressEntity(
                  userId: updated.userId,
                  totalTasks: total,
                  completedTasks: completed,
                  completionRate: total == 0 ? 0.0 : (completed / total),
                  // preserve existing streak if available
                  currentStreakDays: prog.currentStreakDays,
                  lastUpdated: DateTime.now(),
                );
              },
            );

            // Push the updated progress to repository
            await ref.read(updateProgressProvider)(
              updated.userId,
              currentProgress,
            );

            // Refresh progress provider state
            await ref
                .read(progressStateProvider.notifier)
                .fetchUserProgress(updated.userId);
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              task.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14),
                const SizedBox(width: 4),
                Text(
                  dateFormatter.format(task.dueDate),
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColor.withAlpha((0.2 * 255).round()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task.priority.toString().split('.').last.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: priorityColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              // Navigate to edit screen
            } else if (value == 'delete') {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Task'),
                  content: const Text(
                    'Are you sure you want to delete this task?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await notifier.deleteTask(task.id);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
        isThreeLine: true,
        onTap: () {
          // Navigate to task detail
        },
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }
}
