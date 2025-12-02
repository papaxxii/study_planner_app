import 'package:flutter/material.dart';
import 'package:study_planner_app/theme.dart';
import '../../../progress_tracking/presentation/state/progress_state.dart';

class ProgressSummaryWidget extends StatelessWidget {
  final ProgressState progressState;

  const ProgressSummaryWidget({super.key, required this.progressState});

  @override
  Widget build(BuildContext context) {
    if (progressState is ProgressLoading) {
      return const SizedBox(
        height: 150,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (progressState is ProgressError) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.error_outline, size: 32, color: AppColors.error),
                const SizedBox(height: 8),
                Text(
                  'Unable to load progress',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (progressState is ProgressSuccess) {
      final progress = (progressState as ProgressSuccess).progress;
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Circular Progress Indicator
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: progress.completionRate,
                            strokeWidth: 6,
                            backgroundColor: Colors.grey.withAlpha(
                              (0.2 * 255).round(),
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${(progress.completionRate * 100).toStringAsFixed(0)}%',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Complete',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Stats Column
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatRow(
                      'Total Tasks',
                      progress.totalTasks.toString(),
                      Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _buildStatRow(
                      'Completed',
                      progress.completedTasks.toString(),
                      Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _buildStatRow(
                      'Current Streak',
                      '${progress.currentStreakDays}',
                      Colors.orange,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Initial state
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.trending_up,
                size: 32,
                color: AppColors.primary.withAlpha((0.3 * 255).round()),
              ),
              const SizedBox(height: 8),
              Text(
                'Create tasks to see your progress',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
