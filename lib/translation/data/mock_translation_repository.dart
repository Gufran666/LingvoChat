class MockTranslationRepository {
  final List<String> _mockVoicePhrases = [
    'Hello, how are you?',
    'Where is the nearest restaurant?',
    'I need help with translation',
    'What is your name?',
  ];

  Future<String> translateText({
    required String text,
    required String targetLang,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _getMockTranslation(text, targetLang);
  }

  Future<String> detectLanguage(String text) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return 'en';
  }

  String getRandomVoiceText() {
    return _mockVoicePhrases[DateTime.now().millisecond % _mockVoicePhrases.length];
  }

  String _getMockTranslation(String text, String langCode) {
    const translations = {
      'es': 'Spanish',
      'fr': 'French',
      'de': 'German',
      'it': 'Italian',
    };
    return '${text.trim()} [→ ${translations[langCode] ?? langCode.toUpperCase()}]';
  }
}