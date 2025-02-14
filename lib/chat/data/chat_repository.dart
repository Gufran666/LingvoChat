import 'dart:async';
import 'package:language_app/chat/data/conversation_flow.dart';

class ChatRepository {
  Future<String> getGPTResponse(String message) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ConversationFlow.getResponse(message);
  }
}