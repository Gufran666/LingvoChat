import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_app/translation/data/mock_translation_repository.dart';

final translationProvider = StateNotifierProvider<TranslationNotifier, TranslationState>((ref) {
  return TranslationNotifier(MockTranslationRepository());
});

class TranslationState {
  final bool isLoading;
  final String? error;
  final String translatedText;
  final List<Map<String, dynamic>> history;

  TranslationState({
    this.isLoading = false,
    this.error,
    this.translatedText = '',
    this.history = const [],
  });

  TranslationState copyWith({
    bool? isLoading,
    String? error,
    String? translatedText,
    List<Map<String, dynamic>>? history,
  }) {
    return TranslationState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      translatedText: translatedText ?? this.translatedText,
      history: history ?? this.history,
    );
  }
}

class TranslationNotifier extends StateNotifier<TranslationState> {
  final MockTranslationRepository _repo;

  MockTranslationRepository get repository => _repo;

  TranslationNotifier(this._repo) : super(TranslationState());

  Future<void> translate(String text, String targetLang) async {
    if (text.isEmpty) {
      state = state.copyWith(error: 'Please enter text to translate');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final detectedLang = await _repo.detectLanguage(text);
      final result = await _repo.translateText(
        text: text,
        targetLang: targetLang,
      );

      state = state.copyWith(
        isLoading: false,
        translatedText: result,
        history: [
          ...state.history,
          {
            'text': text,
            'translation': result,
            'sourceLang': detectedLang,
            'targetLang': targetLang,
            'timestamp': DateTime.now().toIso8601String(),
          }
        ],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Translation failed: ${e.toString()}',
      );
    }
  }

  void clearHistory() {
    state = state.copyWith(history: []);
  }
}