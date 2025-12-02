import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddReminderScreen extends ConsumerWidget {
  const AddReminderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Add Reminder')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create a New Reminder',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              FormBuilderTextField(
                name: 'title',
                decoration: InputDecoration(
                  labelText: 'Reminder Title',
                  hintText: 'Enter reminder title',
                  prefixIcon: const Icon(Icons.edit_outlined),
                ),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'description',
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter reminder description',
                  prefixIcon: const Icon(Icons.description_outlined),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              FormBuilderDateTimePicker(
                name: 'scheduledTime',
                decoration: const InputDecoration(
                  labelText: 'Scheduled Time',
                  prefixIcon: Icon(Icons.schedule),
                ),
              ),
              const SizedBox(height: 16),
              FormBuilderDropdown<String>(
                name: 'type',
                decoration: const InputDecoration(
                  labelText: 'Reminder Type',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: 'task', child: Text('Task')),
                  DropdownMenuItem(value: 'schedule', child: Text('Schedule')),
                  DropdownMenuItem(value: 'custom', child: Text('Custom')),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.saveAndValidate() ?? false) {
                      // Create ReminderEntity from form values
                      // reminderNotifier.createReminder(newReminder);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Create Reminder'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
