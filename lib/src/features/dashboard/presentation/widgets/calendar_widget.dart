import 'package:flutter/material.dart';
import 'package:study_planner_app/theme.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../task&schedule_management/domain/entities/task_entity.dart';
import '../../../task&schedule_management/presentation/state/task_state.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime focusedDate;
  final Function(DateTime selectedDate, DateTime focusedDate) onDateSelected;
  final TaskState taskState;

  const CalendarWidget({
    super.key,
    required this.selectedDate,
    required this.focusedDate,
    required this.onDateSelected,
    required this.taskState,
  });

  /// Get all tasks
  List<TaskEntity> _getAllTasks() {
    if (taskState is TaskSuccess) {
      return (taskState as TaskSuccess).tasks;
    }
    return [];
  }

  /// Get tasks for a specific date
  List<TaskEntity> _getTasksForDate(DateTime date) {
    final allTasks = _getAllTasks();
    return allTasks.where((task) {
      return task.dueDate.year == date.year &&
          task.dueDate.month == date.month &&
          task.dueDate.day == date.day;
    }).toList();
  }

  /// Get event markers for the calendar
  List<TaskEntity> _getEventsForDay(DateTime day) {
    return _getTasksForDate(day);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar<TaskEntity>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: focusedDate,
          selectedDayPredicate: (day) => isSameDay(selectedDate, day),
          onDaySelected: onDateSelected,
          calendarFormat: CalendarFormat.month,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: Theme.of(context).textTheme.titleLarge!,
            leftChevronIcon: const Icon(Icons.chevron_left),
            rightChevronIcon: const Icon(Icons.chevron_right),
          ),
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: AppColors.primary.withAlpha((0.3 * 255).round()),
              shape: BoxShape.circle,
            ),
            defaultTextStyle: Theme.of(context).textTheme.bodyMedium!,
            weekendTextStyle: Theme.of(context).textTheme.bodyMedium!,
            outsideTextStyle: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Colors.grey),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: Theme.of(context).textTheme.bodySmall!,
            weekendStyle: Theme.of(context).textTheme.bodySmall!,
          ),
          eventLoader: _getEventsForDay,
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (events.isEmpty) return const SizedBox();

              // Count tasks for the day
              final taskCount = events.length;
              return Positioned(
                bottom: 1,
                child: Container(
                  width: 20,
                  height: 6,
                  decoration: BoxDecoration(
                    color: taskCount > 0 ? AppColors.primary : Colors.grey,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
