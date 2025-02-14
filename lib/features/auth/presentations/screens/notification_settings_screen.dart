import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/core/theme/app_theme.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  _NotificationSettingsScreenState createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/profile'),
        ),
        title: Text('Notification Settings', style: AppTheme.textTheme.displayMedium),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile(
              title: Text('Email Notifications', style: AppTheme.textTheme.bodyLarge),
              value: _emailNotifications,
              onChanged: (bool value) {
                setState(() {
                  _emailNotifications = value;
                });
              },
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: Text('Push Notifications', style: AppTheme.textTheme.bodyLarge),
              value: _pushNotifications,
              onChanged: (bool value) {
                setState(() {
                  _pushNotifications = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save notification preferences logic
                // You can use a provider or shared preferences to save the selected preferences
                Navigator.pop(context);
              },
              child: const Text('Save Preferences'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: AppTheme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
