import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/core/theme/app_theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/profile'),
        ),
        title: Text('Help & Support', style: AppTheme.textTheme.displayMedium),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Frequently Asked Questions', style: AppTheme.textTheme.displayMedium?.copyWith(
              color: Colors.white
            )),
            const SizedBox(height: 10),
            _buildFaqItem(
              question: 'How do I reset my password?',
              answer: 'To reset your password, go to the login screen and click on "Forgot Password". Follow the instructions to reset your password.',
            ),
            const SizedBox(height: 10),
            _buildFaqItem(
              question: 'How do I change my email address?',
              answer: 'To change your email address, go to the profile screen and click on "Edit Profile". Update your email address and save the changes.',
            ),
            const SizedBox(height: 10),
            _buildFaqItem(
              question: 'How do I contact support?',
              answer: 'You can contact support by sending an email to support@languageapp.com or by calling our support hotline at (123) 456-7890.',
            ),
            const SizedBox(height: 20),
            Text('Contact Us', style: AppTheme.textTheme.displayMedium),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.email, color: AppTheme.primaryColor),
              title: Text('Email: support@languageapp.com', style: AppTheme.textTheme.bodyLarge),
            ),
            ListTile(
              leading: Icon(Icons.phone, color: AppTheme.primaryColor),
              title: Text('Phone: (123) 456-7890', style: AppTheme.textTheme.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(question, style: AppTheme.textTheme.bodyLarge?.copyWith(color: Colors.black)),
        subtitle: Text(answer, style: AppTheme.textTheme.bodyMedium?.copyWith(color: Colors.white)),
      ),
    );
  }
}
