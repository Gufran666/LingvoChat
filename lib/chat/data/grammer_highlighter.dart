import 'package:flutter/material.dart';
import 'package:language_app/chat/data/message_model.dart';
import 'package:language_app/core/theme/app_theme.dart';

class GrammerHighlighter extends StatelessWidget {
  final String text;
  final List<GrammerError> errors;
  final bool isUser;

  const GrammerHighlighter({
    super.key,
    required this.text,
    required this.errors,
    required this.isUser,
});

  @override
  Widget build(BuildContext context) {
    final spans = text.split(' ').map((word) {
      return TextSpan(
        text: '$word',
        style: AppTheme.textTheme.bodyLarge?.copyWith(
          color: isUser ? Colors.white : Colors.black,
        )
      );
    }).toList();

    for (final error in errors) {
      final start = error.offset;
      final end = start + error.length;
      if (start < text.length && end <= text.length) {
        spans.replaceRange(start, end, [
          TextSpan(
            text: text.substring(start, end),
            style: AppTheme.textTheme.bodyLarge?.copyWith(
              color: Colors.red,
              decoration: TextDecoration.underline,
              decorationColor: Colors.red.withOpacity(0.6),
              decorationStyle: TextDecorationStyle.wavy,
            )
          )
        ]);
      }
    }

    return RichText(
      text: TextSpan(
        style: AppTheme.textTheme.bodyLarge,
        children: spans,
      ),
    );
  }
}