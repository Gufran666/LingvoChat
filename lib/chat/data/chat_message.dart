import 'package:hive/hive.dart';
import 'grammer_error.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 4)
class ChatMessage extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final bool isUser;

  @HiveField(2)
  final String? timestamp;

  @HiveField(3)
  final List<GrammarError>? errors;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.timestamp,
    this.errors,
  });
}
