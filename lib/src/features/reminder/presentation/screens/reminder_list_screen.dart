import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:study_planner_app/theme.dart';
import '../../domain/entities/reminder_entity.dart';
import '../providers/reminder_providers.dart';
import '../state/reminder_state.dart';

class ReminderListScreen extends ConsumerWidget {
  const ReminderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderState = ref.watch(reminderStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reminders'), centerTitle: true),
      body: _buildBody(context, reminderState),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('add_reminder');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ReminderState reminderState) {
    if (reminderState is ReminderInitial) {
      return const Center(child: Text('No reminders yet'));
    } else if (reminderState is ReminderLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (reminderState is ReminderSuccess) {
      if (reminderState.reminders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_none,
                size: 64,
                color: AppColors.primary.withAlpha((0.3 * 255).round()),
              ),
              const SizedBox(height: 16),
              const Text('No reminders yet'),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reminderState.reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminderState.reminders[index];
          return _buildReminderCard(context, reminder);
        },
      );
    } else if (reminderState is ReminderError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(reminderState.message),
          ],
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildReminderCard(BuildContext context, ReminderEntity reminder) {
    final timeFormatter = DateFormat('MMM dd, yyyy - hh:mm a');
    final typeColor = _getReminderTypeColor(reminder.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          reminder.isCompleted
              ? Icons.check_circle
              : Icons.notifications_active,
          color: reminder.isCompleted ? Colors.green : typeColor,
        ),
        title: Text(
          reminder.title,
          style: TextStyle(
            decoration: reminder.isCompleted
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (reminder.description != null)
              Text(
                reminder.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Text(
              timeFormatter.format(reminder.scheduledTime),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: typeColor.withAlpha((0.2 * 255).round()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            reminder.type.toString().split('.').last.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: typeColor,
            ),
          ),
        ),
        isThreeLine: true,
      ),
    );
  }

  Color _getReminderTypeColor(ReminderType type) {
    switch (type) {
      case ReminderType.task:
        return Colors.blue;
      case ReminderType.schedule:
        return Colors.purple;
      case ReminderType.custom:
        return Colors.orange;
    }
  }
}
