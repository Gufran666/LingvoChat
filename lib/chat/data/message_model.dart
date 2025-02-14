class ChatMessage {
  final String text;
  final bool isUser;
  final String? timestamp;
  final List<GrammerError>? errors;

  ChatMessage ({
    required this.text,
    required this.isUser,
    this.timestamp,
    this.errors,
});
}

class GrammerError {
  final int offset;
  final int length;
  final String message;

  GrammerError(this.offset, this.length, this.message);
}