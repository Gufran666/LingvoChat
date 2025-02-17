import 'package:hive/hive.dart';

part 'quiz_question.g.dart';

@HiveType(typeId: 2)
class QuizQuestion {
  @HiveField(0)
  final String questionText;

  @HiveField(1)
  final List<String> options;

  @HiveField(2)
  final int correctAnswerIndex;

  QuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });

  // JSON deserialization
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    String correctAnswer = json['correctAnswer'] ?? "";
    List<String> optionsList = List<String>.from(json['options'] ?? []);

    return QuizQuestion(
      questionText: json['question'] ?? "Unknown Question",
      options: optionsList,
      correctAnswerIndex: optionsList.indexOf(correctAnswer),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'question': questionText,
      'options': options,
      'correctAnswer': options[correctAnswerIndex],
    };
  }
}
