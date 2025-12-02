import 'package:flutter/material.dart';
import 'package:study_planner_app/theme.dart';
import '../../../task&schedule_management/domain/entities/task_entity.dart';
import '../../../task&schedule_management/presentation/state/task_state.dart';

class TodayTasksWidget extends StatelessWidget {
  final DateTime selectedDate;
  final TaskState taskState;

  const TodayTasksWidget({
    super.key,
    required this.selectedDate,
    required this.taskState,
  });

  /// Get tasks for the selected date
  List<TaskEntity> _getTasksForDate() {
    if (taskState is TaskSuccess) {
      final allTasks = (taskState as TaskSuccess).tasks;
      return allTasks.where((task) {
        return task.dueDate.year == selectedDate.year &&
            task.dueDate.month == selectedDate.month &&
            task.dueDate.day == selectedDate.day;
      }).toList();
    }
    return [];
  }

  /// Get priority color
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

  /// Get priority text
  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (taskState is TaskLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final tasksForDate = _getTasksForDate();

    if (tasksForDate.isEmpty) {
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
            Text(
              'No tasks for this day',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    // Sort tasks: incomplete first, then by priority
    final sortedTasks = [...tasksForDate];
    sortedTasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return 0;
    });

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedTasks.length,
      itemBuilder: (context, index) {
        final task = sortedTasks[index];
        return _buildTaskCard(context, task);
      },
    );
  }

  Widget _buildTaskCard(BuildContext context, TaskEntity task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) {
            // Handle checkbox change - integration with state management
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.grey : Colors.black,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              task.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getPriorityColor(
                  task.priority,
                ).withAlpha((0.2 * 255).round()),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _getPriorityText(task.priority),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getPriorityColor(task.priority),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
