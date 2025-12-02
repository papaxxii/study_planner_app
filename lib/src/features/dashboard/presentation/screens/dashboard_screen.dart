import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../task&schedule_management/presentation/providers/task_providers.dart';
import '../../../task&schedule_management/presentation/state/task_state.dart';
import '../../../progress_tracking/presentation/providers/progress_providers.dart';
// ignore: unused_import
import '../../../progress_tracking/presentation/state/progress_state.dart';
import '../../../user_authentication/presentation/providers/user_auth_providers.dart';
import '../../../user_authentication/presentation/state/user_auth_state.dart';
import '../../../user_authentication/domain/entities/user_entity.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/today_tasks_widget.dart';
import '../widgets/progress_summary_widget.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
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
    final taskState = ref.watch(taskStateProvider);
    final progressState = ref.watch(progressStateProvider);
    final authState = ref.watch(authStateProvider);

    // Fetch tasks once when user is available and we have not loaded tasks yet
    if (authState is AuthSuccess && taskState is TaskInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(taskStateProvider.notifier).fetchAllTasks(authState.user.id);
        ref
            .read(progressStateProvider.notifier)
            .fetchUserProgress(authState.user.id);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Summary Section
              // Admin quick actions
              if (authState is AuthSuccess &&
                  authState.user.role == UserRole.admin)
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Admin',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => context.push('/users'),
                              icon: const Icon(Icons.people),
                              label: const Text('Manage Users'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () => context.push('/progress'),
                              icon: const Icon(Icons.bar_chart),
                              label: const Text('System Stats'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                'Progress Summary',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ProgressSummaryWidget(progressState: progressState),
              const SizedBox(height: 32),

              // Calendar Section
              Text(
                'Calendar',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              CalendarWidget(
                selectedDate: _selectedDate,
                focusedDate: _focusedDate,
                onDateSelected: (selectedDate, focusedDate) {
                  setState(() {
                    _selectedDate = selectedDate;
                    _focusedDate = focusedDate;
                  });
                },
                taskState: taskState,
              ),
              const SizedBox(height: 32),

              // Today's Tasks Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tasks for ${DateFormat('MMM d').format(_selectedDate)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_selectedDate.difference(DateTime.now()).inDays == 0)
                    TextButton(
                      onPressed: () {
                        context.pushNamed('add_task');
                      },
                      child: const Text('+ Add'),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              TodayTasksWidget(
                selectedDate: _selectedDate,
                taskState: taskState,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
