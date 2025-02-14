import 'dart:math';

class ConversationFlow {
  static final Map<String, Map<String, dynamic>> scenarios = {
    'greetings': {
      'responses': [
        "Hello! How are you today?",
        "Hi there! What's your name?",
        "Hey! How's your day going?"
      ],
      'triggers': ['hello', 'hi', 'hey']
    },
    'introductions': {
      'responses': [
        "Nice to meet you! Where are you from?",
        "Great! How can I help you today?"
      ],
      'triggers': ['my name is', 'call me']
    },
    'help': {
      'responses': [
        "Sure! What do you need help with?",
        "I'm here to assist you. Ask me anything!"
      ],
      'triggers': ['help', 'assist']
    },
    'goodbye': {
      'responses': [
        "Goodbye! Have a great day!",
        "See you later!",
        "Take care!"
      ],
      'triggers': ['bye', 'goodbye', 'see you']
    }
  };

  static String getResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase().trim();
    final random = Random();

    for (final scenario in scenarios.values) {
      final triggers = scenario['triggers'] as List<String>;
      if (triggers.any((trigger) => lowerMessage.contains(trigger))) {
        final responses = scenario['responses'] as List<String>;
        return responses[random.nextInt(responses.length)];
      }
    }

    // Fallback response
    return "I'm not sure how to respond to that. Can you provide more details?";
  }
}
