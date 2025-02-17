import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:language_app/core/theme/app_theme.dart';
import 'package:language_app/translation/providers/translation_provider.dart';
import 'package:language_app/translation/data/mock_translation_repository.dart';

class TranslateScreen extends ConsumerStatefulWidget {
  const TranslateScreen({super.key});

  @override
  ConsumerState<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends ConsumerState<TranslateScreen> {
  final _textController = TextEditingController();
  String _targetLang = 'es';
  final _translationRepository = MockTranslationRepository();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translationState = ref.watch(translationProvider);
    final notifier = ref.read(translationProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/lessons'),
        ),
        title: Text('Translate', style: AppTheme.textTheme.displayMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showHistoryDialog(context, translationState.history),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleVoiceInput,
        child: const Icon(Icons.mic_none),
        backgroundColor: AppTheme.secondaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLanguageSelector(),
            const SizedBox(height: 20),
            _buildInputField(),
            const SizedBox(height: 20),
            _buildTranslateButton(notifier),
            const SizedBox(height: 20),
            _buildTranslationResult(translationState),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text('Detected: English', style: TextStyle(fontSize: 14)),
        const Icon(Icons.arrow_forward),
        DropdownButton<String>(
          value: _targetLang,
          items: const [
            DropdownMenuItem(value: 'es', child: Text('Spanish 🇪🇸')),
            DropdownMenuItem(value: 'fr', child: Text('French 🇫🇷')),
            DropdownMenuItem(value: 'de', child: Text('German 🇩🇪')),
            DropdownMenuItem(value: 'it', child: Text('Italian 🇮🇹')),
          ],
          onChanged: (value) => setState(() => _targetLang = value!),
        ),
      ],
    );
  }

  Widget _buildInputField() {
    return TextField(
      controller: _textController,
      decoration: InputDecoration(
        hintText: 'Type or speak text...',
        hintStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      maxLines: 3,
      style: TextStyle(color: Colors.black),
      maxLength: 3,
    );
  }

  Widget _buildTranslateButton(TranslationNotifier notifier) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.translate),
      label: const Text('Translate Now'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () => _triggerTranslation(notifier),
    );
  }

  void _triggerTranslation(TranslationNotifier notifier) async {
    final text = _textController.text;
    if (text.isNotEmpty) {
      await notifier.translate(text, _targetLang);
    }
  }

  Widget _buildTranslationResult(TranslationState state) {
    return Expanded(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: state.isLoading
            ? _buildShimmerLoader()
            : _buildResultContent(state),
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200,
              height: 20,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 18,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultContent(TranslationState state) {
    if (state.error != null) {
      return _buildErrorDisplay(state.error!);
    }
    if (state.translatedText.isNotEmpty) {
      return _buildTranslatedText(state.translatedText);
    }
    return _buildEmptyState();
  }

  Widget _buildErrorDisplay(String error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppTheme.errorColor),
          const SizedBox(width: 10),
          Expanded(child: Text(error, style: AppTheme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildTranslatedText(String text) {
    return SingleChildScrollView(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Text(
          text,
          key: ValueKey(text),
          style: AppTheme.textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.translate, size: 50, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          Text(
            'Your translations will appear here',
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _handleVoiceInput() {
    final mockText = _translationRepository.getRandomVoiceText();
    setState(() => _textController.text = mockText);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice input simulated'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showHistoryDialog(BuildContext context, List<Map<String, dynamic>> history) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Translation History'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: history.length,
            itemBuilder: (ctx, index) {
              final entry = history.reversed.toList()[index];
              return ListTile(
                title: Text(entry['text']),
                subtitle: Text(entry['translation']),
                trailing: Text(
                  entry['timestamp'].toString().substring(0, 16),
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(translationProvider.notifier).clearHistory();
              Navigator.pop(ctx);
            },
            child: const Text('Clear History'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
