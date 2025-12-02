import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_planner_app/theme.dart';
import '../providers/progress_providers.dart';
import '../state/progress_state.dart';

class ProgressDashboardScreen extends ConsumerWidget {
  const ProgressDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(progressStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Progress'), centerTitle: true),
      body: _buildBody(context, progressState),
    );
  }

  Widget _buildBody(BuildContext context, ProgressState progressState) {
    if (progressState is ProgressInitial) {
      return const Center(child: Text('No progress data yet'));
    } else if (progressState is ProgressLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (progressState is ProgressSuccess) {
      final progress = progressState.progress;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Completion Rate Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Completion Rate',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: progress.completionRate,
                            strokeWidth: 8,
                            backgroundColor: Colors.grey.withAlpha(
                              (0.3 * 255).round(),
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                        Text(
                          '${(progress.completionRate * 100).toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Stats Grid
            Text('Statistics', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard(
                  'Total Tasks',
                  progress.totalTasks.toString(),
                  Icons.task_outlined,
                  Colors.blue,
                ),
                _buildStatCard(
                  'Completed',
                  progress.completedTasks.toString(),
                  Icons.check_circle_outline,
                  Colors.green,
                ),
                _buildStatCard(
                  'Current Streak',
                  '${progress.currentStreakDays} days',
                  Icons.local_fire_department_outlined,
                  Colors.orange,
                ),
                _buildStatCard(
                  'Pending',
                  (progress.totalTasks - progress.completedTasks).toString(),
                  Icons.pending_outlined,
                  Colors.red,
                ),
              ],
            ),
          ],
        ),
      );
    } else if (progressState is ProgressError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(progressState.message),
          ],
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
