import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/core/theme/app_theme.dart';
import 'package:language_app/features/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/home')
        ),
        title: Text('User Profile', style: AppTheme.textTheme.displayMedium),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(user?.email),
            const SizedBox(height: 20),
            _buildAchievements(),
            const SizedBox(height: 20),
            _buildSettings(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String? email) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppTheme.primaryColor,
            child: Text(
              email != null ? email[0].toUpperCase() : 'G',
              style: const TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(email ?? 'Guest', style: AppTheme.textTheme.displayMedium),
                const SizedBox(height: 4),
                Text('Language Learner', style: AppTheme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Achievements', style: AppTheme.textTheme.displayMedium?.copyWith(color: Colors.white)),
          const SizedBox(height: 10),
          _buildAchievementCard(
            icon: Icons.star,
            title: 'Completed 10 Lessons',
            description: 'You have completed 10 lessons!',
          ),
          const SizedBox(height: 10),
          _buildAchievementCard(
            icon: Icons.quiz,
            title: 'Taken 5 Quizzes',
            description: 'You have taken 5 quizzes!',
          ),
          const SizedBox(height: 10),
          _buildAchievementCard(
            icon: Icons.timer,
            title: 'Spent 5 Hours',
            description: 'You have spent 5 hours learning!',
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor, size: 40),
        title: Text(title, style: AppTheme.textTheme.bodyLarge?.copyWith(color: Colors.white)),
        subtitle: Text(description, style: AppTheme.textTheme.bodyMedium?.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _buildSettings(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: AppTheme.textTheme.displayMedium?.copyWith(color: Colors.white)),
          const SizedBox(height: 10),
          _buildSettingsItem(
            context,
            icon: Icons.person,
            title: 'Edit Profile',
            onTap: () {
              GoRouter.of(context).go('/edit-profile');
            },
          ),
          const SizedBox(height: 10),
          _buildSettingsItem(
            context,
            icon: Icons.language,
            title: 'Language Preferences',
            onTap: () {
              GoRouter.of(context).go('/language-preferences');
            },
          ),
          const SizedBox(height: 10),
          _buildSettingsItem(
            context,
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              GoRouter.of(context).go('/notification-settings');
            },
          ),
          const SizedBox(height: 10),
          _buildSettingsItem(
            context,
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () {
              GoRouter.of(context).go('/help-support');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor, size: 30),
      title: Text(title, style: AppTheme.textTheme.bodyLarge?.copyWith(color: Colors.white)),
      onTap: onTap,
    );
  }
}
