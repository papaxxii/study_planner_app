import 'package:flutter/material.dart';

// ignore: duplicate_import
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';

/// Simple in-memory settings providers (not persisted) — UI only for now
final demoDataProvider = StateProvider<bool>((ref) => false);
final usePurpleThemeProvider = StateProvider<bool>((ref) => true);

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final demoEnabled = ref.watch(demoDataProvider);
        final purple = ref.watch(usePurpleThemeProvider);

        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SwitchListTile(
                title: const Text('Enable Demo Data (debug only)'),
                subtitle: const Text(
                  'Shows demo tasks when your Firestore is empty',
                ),
                value: demoEnabled,
                onChanged: (v) => ref.read(demoDataProvider.notifier).state = v,
              ),
              SwitchListTile(
                title: const Text('Use Purple Theme'),
                subtitle: const Text(
                  'Toggle the app purple accent (in-memory)',
                ),
                value: purple,
                onChanged: (v) =>
                    ref.read(usePurpleThemeProvider.notifier).state = v,
              ),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('About'),
                subtitle: const Text('Study Planner — demo version'),
                onTap: () => context.push('/progress'),
              ),
            ],
          ),
        );
      },
    );
  }
}
