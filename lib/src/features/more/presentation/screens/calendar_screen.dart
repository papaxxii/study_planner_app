import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:study_planner_app/src/features/dashboard/presentation/widgets/calendar_widget.dart';
import 'package:study_planner_app/src/features/dashboard/presentation/widgets/today_tasks_widget.dart';
import '../../../task&schedule_management/presentation/providers/task_providers.dart';
import '../../../task&schedule_management/presentation/state/task_state.dart';
import '../../../user_authentication/presentation/providers/user_auth_providers.dart';
import '../../../user_authentication/presentation/state/user_auth_state.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _selectedDate;
  late DateTime _focusedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _focusedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final taskState = ref.watch(taskStateProvider);

    // Fetch user's tasks once
    if (authState is AuthSuccess && taskState is TaskInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(taskStateProvider.notifier).fetchAllTasks(authState.user.id);
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalendarWidget(
              selectedDate: _selectedDate,
              focusedDate: _focusedDate,
              onDateSelected: (selected, focused) {
                setState(() {
                  _selectedDate = selected;
                  _focusedDate = focused;
                });
                if (authState is AuthSuccess) {
                  ref
                      .read(taskStateProvider.notifier)
                      .fetchTasksByDate(authState.user.id, selected);
                }
              },
              taskState: taskState,
            ),
            const SizedBox(height: 16),
            Text(
              'Tasks for ${DateFormat.yMMMd().format(_selectedDate)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            TodayTasksWidget(selectedDate: _selectedDate, taskState: taskState),
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
