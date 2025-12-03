import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../task&schedule_management/presentation/providers/task_providers.dart';
import 'package:go_router/go_router.dart';
import '../../../task&schedule_management/presentation/state/task_state.dart';
import '../../../task&schedule_management/domain/entities/task_entity.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskStateProvider);

    // Group tasks by goal type
    Map<GoalType, List<TaskEntity>> grouped = {};
    if (taskState is TaskSuccess) {
      for (final t in taskState.tasks) {
        grouped.putIfAbsent(t.goalType, () => []).add(t);
      }
    }

    Widget buildGoalCard(GoalType type, List<TaskEntity> tasks) {
      final completed = tasks.where((t) => t.isCompleted).length;
      final total = tasks.length;
      String title;
      switch (type) {
        case GoalType.daily:
          title = 'Daily Goals';
          break;
        case GoalType.weekly:
          title = 'Weekly Goals';
          break;
        case GoalType.exam:
          title = 'Exam Goals';
          break;
        default:
          title = 'Uncategorized';
      }

      return Card(
        child: ListTile(
          title: Text(title),
          subtitle: Text('$completed of $total completed'),
          trailing: CircularProgressIndicator(
            value: total == 0 ? 0 : (completed / total),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: taskState is TaskLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Goals',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (grouped.isEmpty) ...[
                    const Center(
                      child: Text(
                        'No goals found. Create tasks and tag them with a goal type.',
                      ),
                    ),
                  ] else ...[
                    if (grouped.containsKey(GoalType.daily))
                      buildGoalCard(GoalType.daily, grouped[GoalType.daily]!),
                    if (grouped.containsKey(GoalType.weekly))
                      buildGoalCard(GoalType.weekly, grouped[GoalType.weekly]!),
                    if (grouped.containsKey(GoalType.exam))
                      buildGoalCard(GoalType.exam, grouped[GoalType.exam]!),
                    if (grouped.containsKey(GoalType.none))
                      buildGoalCard(GoalType.none, grouped[GoalType.none]!),
                  ],
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed('add_task'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
