import 'package:flutter/material.dart';
import 'package:language_app/chat/data/message_model.dart';
import 'package:language_app/core/theme/app_theme.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser
              ? AppTheme.primaryColor
              : AppTheme.surfaceColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 16 : 0),
            bottomRight: Radius.circular(message.isUser ? 0 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: AppTheme.textTheme.bodyLarge?.copyWith(
                color: message.isUser ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.timestamp ?? 'Time not available',
              style: AppTheme.textTheme.bodySmall?.copyWith(
                color: message.isUser ? Colors.white70 : Colors.black54,
              ),
            )
          ],
        ),
      ),
    );
  }
}