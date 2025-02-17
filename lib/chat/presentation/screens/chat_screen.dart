import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/core/theme/app_theme.dart';
import 'package:language_app/chat/data/chat_repository.dart';
import 'package:language_app/chat/presentation/widgets/message_bubble.dart';
import 'package:language_app/chat/data/message_model.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';
import 'package:language_app/chat/data/conversation_flow.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late Box<ChatMessage> _chatBox;
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ChatRepository _chatRepository = ChatRepository();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    try {
      print("Opening Hive Box...");
      if (!Hive.isBoxOpen('chatHistory')) {
        _chatBox = await Hive.openBox<ChatMessage>('chatHistory');
        print("Hive Box Opened Successfully");
      } else {
        _chatBox = Hive.box<ChatMessage>('chatHistory');
        print("Hive Box Already Open");
      }

      print("Loading messages from Hive...");
      setState(() {
        _messages.addAll(_chatBox.values.toList());
        _isLoading = false;
      });

      print("Loaded messages: ${_messages.length}");
    } catch (e) {
      print("Error opening Hive box: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Building UI - isLoading: $_isLoading");

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: Text('Chat With AI', style: AppTheme.textTheme.displayMedium),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: clearHistory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _messages.length,
                itemBuilder: (ctx, i) {
                  return AnimationConfiguration.staggeredList(
                    position: i,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: MessageBubble(message: _messages[i]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: AppTheme.surfaceColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _sendMessage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.all(12.0),
            ),
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final userMessage = ChatMessage(
      text: _messageController.text,
      isUser: true,
      timestamp: DateTime.now().toLocal().toString().substring(0, 16),
    );

    setState(() {
      _messages.add(userMessage);
      _messageController.clear();
    });

    await _chatBox.add(userMessage);
    print("User message saved: ${userMessage.text}");

    setState(() => _isLoading = true);

    try {
      print("Fetching AI response...");
      final response = ConversationFlow.getResponse(userMessage.text);
      print("AI Response: $response");

      final botMessage = ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now().toLocal().toString().substring(0, 16),
      );

      await _chatBox.add(botMessage);
      print("Bot message saved");

      setState(() {
        _messages.add(botMessage);
        _isLoading = false;
      });

      print("Chat history updated");
    } catch (e) {
      print("Error processing AI response: $e");
      setState(() => _isLoading = false);
    }
  }

  void clearHistory() async {
    print("Clearing chat history...");
    await _chatBox.clear();
    setState(() => _messages.clear());
    print("Chat history cleared");
  }
}
