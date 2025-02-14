import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:language_app/chat/data/message_model.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ValueListenableBuilder<Box<ChatMessage>>(
        valueListenable: Hive.box<ChatMessage>('chatHistory').listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No chat history available.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final message = box.getAt(index)!;
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.blue : Colors.black87,
                      fontWeight: message.isUser ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(message.isUser ? 'You' : 'Bot'),
                  trailing: Text(
                    DateFormat('MMM dd, HH:mm').format(DateTime.parse(message.timestamp!)),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
