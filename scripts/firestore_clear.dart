// ignore_for_file: avoid_print
// A small utility to remove seeded documents listed in scripts/seed_data.json
// Run from project root with:
//   dart run scripts/firestore_clear.dart

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:study_planner_app/firebase_options.dart';

Future<void> main(List<String> args) async {
  print('🧹 Starting Firestore clear script');
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
  final seedFile = File('scripts/seed_data.json');
  if (!await seedFile.exists()) {
    print('❌ Missing scripts/seed_data.json');
    exit(1);
  }

  final raw = await seedFile.readAsString();
  final Map<String, dynamic> data = jsonDecode(raw) as Map<String, dynamic>;

  // Delete users
  final users = (data['users'] as List<dynamic>?) ?? [];
  print('\n🗑️ Deleting users (${users.length})...');
  for (final u in users) {
    final id = (u as Map)['id'] as String;
    await firestore.collection('users').doc(id).delete().catchError((e) {
      print('  ⚠️ Could not delete user $id: $e');
    });
    print('  ✓ User deleted: $id');
  }

  // Delete tasks
  final tasks = (data['tasks'] as List<dynamic>?) ?? [];
  print('\n🗑️ Deleting tasks (${tasks.length})...');
  for (final t in tasks) {
    final id = (t as Map)['id'] as String;
    await firestore.collection('tasks').doc(id).delete().catchError((e) {
      print('  ⚠️ Could not delete task $id: $e');
    });
    print('  ✓ Task deleted: $id');
  }

  // Delete reminders
  final reminders = (data['reminders'] as List<dynamic>?) ?? [];
  print('\n🗑️ Deleting reminders (${reminders.length})...');
  for (final r in reminders) {
    final id = (r as Map)['id'] as String;
    await firestore.collection('reminders').doc(id).delete().catchError((e) {
      print('  ⚠️ Could not delete reminder $id: $e');
    });
    print('  ✓ Reminder deleted: $id');
  }

  print('\n✅ Clear completed');
}
