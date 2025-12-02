# UI Screens - Quick Reference

## File Locations

### User Authentication
- `lib/src/features/user_authentication/presentation/screens/login_screen.dart`
- `lib/src/features/user_authentication/presentation/screens/profile_screen.dart`

### Task Management
- `lib/src/features/task&schedule_management/presentation/screens/task_list_screen.dart`
- `lib/src/features/task&schedule_management/presentation/screens/add_task_screen.dart`

### Reminders
- `lib/src/features/reminder/presentation/screens/reminder_list_screen.dart`
- `lib/src/features/reminder/presentation/screens/add_reminder_screen.dart`

### Progress Tracking
- `lib/src/features/progress_tracking/presentation/screens/progress_dashboard_screen.dart`

### Admin Management
- `lib/src/features/admin_user_management/presentation/screens/user_list_screen.dart`
- `lib/src/features/admin_user_management/presentation/screens/edit_user_role_screen.dart`

---

## Screen Features Matrix

| Feature | List | Add/Edit | Detail | Dashboard |
|---------|------|----------|--------|-----------|
| User Auth | - | LoginScreen | ProfileScreen | - |
| Tasks | TaskListScreen | AddTaskScreen | - | - |
| Reminders | ReminderListScreen | AddReminderScreen | - | - |
| Progress | - | - | - | ProgressDashboardScreen |
| Admin | UserListScreen | EditUserRoleScreen | - | - |

---

## Key Features Summary

### LoginScreen
- Email/Password validation
- Form-based authentication
- Error/Success messaging
- Sign-up link

### ProfileScreen
- User info display
- Avatar with fallback
- Role badge
- Logout functionality

### TaskListScreen
- Task list with checkboxes
- Priority indicators
- Due date display
- Edit/Delete menu

### AddTaskScreen
- Title, description, date, priority
- Form validation
- 3-field title requirement

### ReminderListScreen
- Reminder list with times
- Type indicators
- Completion status
- Strikethrough support

### AddReminderScreen
- Title, description, time, type
- Optional description field
- Dropdown type selector

### ProgressDashboardScreen
- Circular progress indicator
- 4-stat grid layout
- Color-coded statistics
- Percentage display

### UserListScreen
- User list with avatars
- Role badges
- Active/Inactive status
- Edit/Delete menu

### EditUserRoleScreen
- Role selector dropdown
- Active status toggle
- Delete confirmation dialog
- User info card

---

## State Integration Points

### Authentication
```dart
ref.watch(authStateProvider)
authNotifier.login(email, password)
authNotifier.logout()
authNotifier.fetchUserProfile(userId)
authNotifier.updateProfile(user)
```

### Tasks
```dart
ref.watch(taskStateProvider)
taskNotifier.addTask(task)
taskNotifier.updateTask(task)
taskNotifier.deleteTask(taskId)
taskNotifier.fetchAllTasks(userId)
taskNotifier.fetchTasksByDate(userId, date)
```

### Reminders
```dart
ref.watch(reminderStateProvider)
reminderNotifier.createReminder(reminder)
reminderNotifier.deleteReminder(reminderId)
reminderNotifier.fetchUserReminders(userId)
reminderNotifier.sendNotification(userId, title, body, time)
```

### Progress
```dart
ref.watch(progressStateProvider)
progressNotifier.fetchUserProgress(userId)
progressNotifier.fetchDailyProgress(userId, date)
progressNotifier.update(userId, progress)
```

### Admin
```dart
ref.watch(adminUserStateProvider)
adminNotifier.fetchAllUsers()
adminNotifier.fetchUserDetails(userId)
adminNotifier.updateUserRole(userId, newRole)
adminNotifier.deleteUserAccount(userId)
```

---

## Form Validators Used

| Validator | Usage |
|-----------|-------|
| `required()` | Mandatory fields |
| `email()` | Email format validation |
| `minLength(n)` | Minimum character requirement |
| `compose([...])` | Multiple validators |

---

## Color Scheme (from theme.dart)

| Element | Color |
|---------|-------|
| Primary | #4B39EF (Poppins headings) |
| Secondary | #00BFA6 (Teal accents) |
| Error | #B00020 (Red alerts) |
| Success | Green (implicit) |
| Disabled | #9AA4B2 (Gray) |

---

## Material Design 3 Features

✅ Rounded corners (12px)
✅ Material elevation
✅ Smooth animations
✅ Color scheme adherence
✅ Typography hierarchy
✅ Consistent spacing

---

## Dependencies Used

- `flutter_riverpod` - State management
- `flutter_form_builder` - Form handling
- `form_builder_validators` - Input validation
- `google_fonts` - Typography
- `intl` - Date/time formatting

---

## Code Template: Adding a New Screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_planner_app/theme.dart';
import '../providers/[feature]_providers.dart';
import '../state/[feature]_state.dart';

class [FeatureName]Screen extends ConsumerWidget {
  const [FeatureName]Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch([feature]StateProvider);
    final notifier = ref.read([feature]StateProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('[Title]')),
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, [Feature]State state) {
    if (state is [Feature]Loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is [Feature]Success) {
      // Build success UI
    } else if (state is [Feature]Error) {
      return Center(child: Text(state.message));
    }
    return const Center(child: CircularProgressIndicator());
  }
}
```

---

## Common Patterns

### Empty State
```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.inbox_outlined, size: 64),
      const SizedBox(height: 16),
      const Text('No items yet'),
    ],
  ),
)
```

### Error State
```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.error_outline, size: 64, color: AppColors.error),
      const SizedBox(height: 16),
      Text(error.message),
    ],
  ),
)
```

### Form Validation
```dart
if (formKey.currentState?.saveAndValidate() ?? false) {
  final values = formKey.currentState?.value;
  // Use values to create entity and call notifier
}
```

