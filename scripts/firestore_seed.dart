// ignore_for_file: avoid_print
// A simple Firestore seed script for UAT.
// Run from project root with:
//   dart run scripts/firestore_seed.dart

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:study_planner_app/firebase_options.dart';

Future<void> main(List<String> args) async {
  print('🌱 Starting Firestore seed script');

  // Initialize Firebase with generated options for the current platform
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('✓ Firebase initialized');

  final firestore = FirebaseFirestore.instance;
  // Optionally route to Firestore emulator when FIRESTORE_EMULATOR_HOST is set
  final emulatorHost = Platform.environment['FIRESTORE_EMULATOR_HOST'];
  if (emulatorHost != null && emulatorHost.isNotEmpty) {
    final parts = emulatorHost.split(':');
    final host = parts[0];
    final port = parts.length > 1 ? int.tryParse(parts[1]) ?? 8080 : 8080;
    firestore.useFirestoreEmulator(host, port);
    print('⚙️ Using Firestore emulator at $host:$port');
  }

  // Read seed data
  final seedFile = File('scripts/seed_data.json');
  if (!await seedFile.exists()) {
    print('❌ Missing scripts/seed_data.json');
    exit(1);
  }

  final raw = await seedFile.readAsString();
  final Map<String, dynamic> data = jsonDecode(raw) as Map<String, dynamic>;

  // Seed users
  final users = (data['users'] as List<dynamic>?) ?? [];
  print('\n📝 Seeding users (${users.length})...');
  for (final u in users) {
    final map = Map<String, dynamic>.from(u as Map);
    final id = map.remove('id') as String;
    await firestore.collection('users').doc(id).set(map);
    print('  ✓ User created: $id');
  }

  // Seed tasks
  final tasks = (data['tasks'] as List<dynamic>?) ?? [];
  print('\n📝 Seeding tasks (${tasks.length})...');
  for (final t in tasks) {
    final map = Map<String, dynamic>.from(t as Map);
    final id = map.remove('id') as String;
    // convert date strings to Timestamps if present
    if (map.containsKey('dueDate') && map['dueDate'] is String) {
      try {
        map['dueDate'] = Timestamp.fromDate(
          DateTime.parse(map['dueDate'] as String),
        );
      } catch (_) {}
    }
    if (map.containsKey('createdAt') && map['createdAt'] is String) {
      try {
        map['createdAt'] = Timestamp.fromDate(
          DateTime.parse(map['createdAt'] as String),
        );
      } catch (_) {}
    }
    await firestore.collection('tasks').doc(id).set(map);
    print('  ✓ Task created: $id');
  }

  // Seed reminders
  final reminders = (data['reminders'] as List<dynamic>?) ?? [];
  print('\n📝 Seeding reminders (${reminders.length})...');
  for (final r in reminders) {
    final map = Map<String, dynamic>.from(r as Map);
    final id = map.remove('id') as String;
    if (map.containsKey('scheduledTime') && map['scheduledTime'] is String) {
      try {
        map['scheduledTime'] = Timestamp.fromDate(
          DateTime.parse(map['scheduledTime'] as String),
        );
      } catch (_) {}
    }
    await firestore.collection('reminders').doc(id).set(map);
    print('  ✓ Reminder created: $id');
  }

  print('\n✅ Firestore seeding completed successfully!');
}
