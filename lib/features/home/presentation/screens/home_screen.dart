import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/core/theme/app_theme.dart';
import 'package:language_app/features/providers/auth_provider.dart';
import 'package:language_app/learning/data/lesson_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final lesson = Lesson(
      id: '1',
      title: 'Example Lesson',
      content: [
        LessonContent(
          type: 'String',
          data: 'This is the content of the lesson',
        ),
      ],
      quizQuestions: [],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('LingvoChat', style: AppTheme.textTheme.displayMedium),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeBanner(user?.displayName),
            const SizedBox(height: 20),
            _buildQuickAccessButtons(context, lesson),
            const SizedBox(height: 20),
            _buildUserProfile(context, user?.displayName),
            const SizedBox(height: 20),
            _buildDailyGoalsAndAchievements(),
            const SizedBox(height: 20),
            _buildNotifications(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner(String? username) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        'Hello, ${username ?? 'Guest'}',
        style: AppTheme.textTheme.displayLarge?.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildQuickAccessButtons(BuildContext context, Lesson lesson) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: _buildQuickAccessButton(
            context,
            icon: Icons.book,
            label: 'Lessons',
            onPressed: () {
              GoRouter.of(context).go('/lessons', extra: lesson);
            },
          ),
        ),
        Expanded(
          child: _buildQuickAccessButton(
            context,
            icon: Icons.quiz,
            label: 'Quizzes',
            onPressed: () {
              GoRouter.of(context).go('/quiz', extra: lesson);
            },
          ),
        ),
        Expanded(
          child: _buildQuickAccessButton(
            context,
            icon: Icons.chat,
            label: 'Chat',
            onPressed: () {
              GoRouter.of(context).go('/chat');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed}) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 40, color: AppTheme.surfaceColor),
          onPressed: onPressed,
        ),
        Text(label, style: AppTheme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildUserProfile(BuildContext context, String? username) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).go('/profile');
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white70,
              child: Text(
                (username != null && username.isNotEmpty) ? username[0].toUpperCase() : 'G',
                style: const TextStyle(fontSize: 24, color: Colors.black),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username ?? 'Guest', style: AppTheme.textTheme.displayMedium?.copyWith(color: AppTheme.surfaceColor)),
                const SizedBox(height: 4),
                Text('Mobile Aplication developer', style: AppTheme.textTheme.bodyLarge?.copyWith(color: AppTheme.surfaceColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyGoalsAndAchievements() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.deepOrange[300],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daily Goals', style: AppTheme.textTheme.displayMedium?.copyWith(color: AppTheme.surfaceColor)),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.6,
            minHeight: 8,
            color: AppTheme.textColor,
            backgroundColor: Colors.grey.shade200,
          ),
          const SizedBox(height: 10),
          Text(
            'Complete 2 lessons today!',
            style: AppTheme.textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text('Achievements', style: AppTheme.textTheme.displayMedium?.copyWith(color: AppTheme.surfaceColor)),
          const SizedBox(height: 10),
          Text(
            'You have completed 10 lessons!',
            style: AppTheme.textTheme.bodyLarge?.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 10),
          Text(
            'You have taken 5 quizzes!',
            style: AppTheme.textTheme.bodyLarge?.copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildNotifications() {
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
          Text('Notifications', style: AppTheme.textTheme.displayMedium),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.notification_important, color: AppTheme.primaryColor),
            title: Text('New lesson available!', style: AppTheme.textTheme.bodyMedium),
          ),
          ListTile(
            leading: Icon(Icons.notification_important, color: AppTheme.primaryColor),
            title: Text('Quiz results are in!', style: AppTheme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
