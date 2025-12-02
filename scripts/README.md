# Firestore Seed Script

This directory contains scripts to seed your Firestore database with initial data for user acceptance testing (UAT).

## Files

- **`firestore_seed.dart`** - Main Dart script that seeds all collections (users, tasks, reminders)
- **`seed_data.json`** - JSON file containing the seed data structure and sample records

## What Gets Seeded

The script populates the following Firestore collections:

### Users (3 records)
- 2 client users (Alice Johnson, Bob Smith)
- 1 admin user for testing admin functionality

### Tasks (5 records)
- Mixed priorities (high, medium)
- Various completion statuses
- Realistic due dates for testing scheduling features

### Reminders (3 records)
- Different reminder types (task, schedule)
- Associated with test users
- Scheduled for near-future dates

## How to Run

### Prerequisites
1. Ensure your Flutter project has all dependencies installed:
   ```bash
   flutter pub get
   ```

2. Make sure you're running on a platform supported by your app (web, Android, iOS, macOS, or Windows)

3. Have your Firebase project set up and configured (already done in `lib/firebase_options.dart`)

### Running the Seed Script

From the project root directory:

```bash
# For web platform
dart run scripts/firestore_seed.dart

# Or for other platforms, specify the target
dart run scripts/firestore_seed.dart
```

### Expected Output

```
🌱 Initializing Firebase Firestore Seed Script
============================================================
✓ Firebase initialized successfully
✓ Firestore instance created
✓ Seed data loaded successfully

📝 Seeding users...
  ✓ User created: Alice Johnson (alice@example.com)
  ✓ User created: Bob Smith (bob@example.com)
  ✓ User created: Admin User (admin@example.com)
✓ 3 users seeded

📝 Seeding tasks...
  ✓ Task created: Complete Math Assignment
  ✓ Task created: Read Chapter 3 of Literature
  ✓ Task created: Physics Lab Report
  ✓ Task created: Chemistry Quiz Preparation
  ✓ Task created: History Essay
✓ 5 tasks seeded

📝 Seeding reminders...
  ✓ Reminder created: Math Assignment Due
  ✓ Reminder created: Study Session
  ✓ Reminder created: Chemistry Quiz in 1 hour
✓ 3 reminders seeded

============================================================
✓ Firestore seeding completed successfully!
  - Users: 3
  - Tasks: 5
  - Reminders: 3
============================================================
```

## Modifying Seed Data

Edit `seed_data.json` to customize the initial data:

1. **Add/Remove Records**: Simply add or remove objects from the arrays
2. **Change Values**: Modify any field values (name, email, title, etc.)
3. **Update IDs**: Each record must have a unique `id` field
4. **Date Formats**: Use ISO 8601 format for dates (e.g., `2025-12-15T17:00:00.000Z`)

### Example: Adding a New Task

```json
{
  "id": "task_006",
  "userId": "user_001",
  "title": "Biology Project",
  "description": "Complete the ecosystem project",
  "dueDate": "2025-12-25T17:00:00.000Z",
  "isCompleted": false,
  "priority": "medium",
  "createdAt": "2025-11-28T10:00:00.000Z"
}
```

## Safety & Best Practices

1. **Backup First**: Before running the script on a real Firebase project, consider exporting your current data
2. **Test Locally**: Test the script locally first before running it against your UAT Firebase project
3. **Use UAT Project**: Always seed into your staging/UAT Firebase project, never production
4. **Idempotent Writes**: The script uses `.set()` which overwrites existing documents with the same IDs, making it safe to run multiple times
5. **Data Validation**: The script validates that `seed_data.json` exists before running

## Clearing Seeded Data

To remove all seeded data:

1. Go to the [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Navigate to Firestore Database
4. Select each collection (users, tasks, reminders) and delete all documents

Or use the `firebase-cli`:
```bash
firebase firestore:delete users --recursive
firebase firestore:delete tasks --recursive
firebase firestore:delete reminders --recursive
```

## Troubleshooting

### Issue: "seed_data.json not found"
- Make sure you're running the script from the project root directory
- Verify that `scripts/seed_data.json` exists

### Issue: Firebase initialization fails
- Verify your Firebase configuration in `lib/firebase_options.dart`
- Ensure your Firebase project is properly set up in Firebase Console
- Check that you have internet connectivity

### Issue: Permission denied errors
- Ensure your Firebase authentication is set up correctly
- Verify Firestore security rules allow write access
- For development, you can temporarily set rules to allow all:
  ```
  rules_version = '2';
  service cloud.firestore {
    match /databases/{database}/documents {
      match /{document=**} {
        allow read, write;
      }
    }
  }
  ```

## Notes

- The script uses `Timestamp.fromDate()` to properly convert date strings to Firestore Timestamps
- All sample user IDs start with `user_` for easy identification
- All sample task IDs start with `task_` for easy identification
- All sample reminder IDs start with `reminder_` for easy identification
- The script exits with code 0 on success, 1 on failure (useful for CI/CD pipelines)
