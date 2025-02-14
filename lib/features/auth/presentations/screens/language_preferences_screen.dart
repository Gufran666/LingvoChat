import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/core/theme/app_theme.dart';

class LanguagePreferencesScreen extends ConsumerWidget {
  LanguagePreferencesScreen({super.key});

  final List<String> languages = ['English', 'Spanish', 'French', 'German', 'Chinese'];
  final List<String> selectedLanguages = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/profile'),
        ),
        title: Text('Language Preferences', style: AppTheme.textTheme.displayMedium?.copyWith(color: Colors.tealAccent)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center( // Center the contents of the screen
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Center the contents of the column
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Select your preferred languages:', style: AppTheme.textTheme.bodyLarge?.copyWith(color: Colors.white)),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final language = languages[index];
                    final isSelected = selectedLanguages.contains(language);

                    return Card(
                      color: Colors.black, // Change this color to your desired card color
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(language, style: AppTheme.textTheme.bodyMedium?.copyWith(color: Colors.white)),
                        trailing: isSelected
                            ? Icon(Icons.check_circle, color: AppTheme.primaryColor)
                            : Icon(Icons.check_circle_outline),
                        onTap: () {
                          if (isSelected) {
                            selectedLanguages.remove(language);
                          } else {
                            selectedLanguages.add(language);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the profile screen
                },
                child: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  textStyle: AppTheme.textTheme.bodyMedium?.copyWith(color: Colors.white), // Change button text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
