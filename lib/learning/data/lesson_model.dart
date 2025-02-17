import 'package:hive/hive.dart';
import 'quiz_question.dart';

part 'lesson_model.g.dart';

@HiveType(typeId: 0)
class Lesson {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<LessonContent> content;

  @HiveField(3)
  final bool isCompleted;

  @HiveField(4)
  final List<QuizQuestion> quizQuestions;

  Lesson({
    required this.id,
    required this.title,
    required this.content,
    this.isCompleted = false,
    required this.quizQuestions,
  });

  Lesson copyWith({
    bool? isCompleted,
  }) {
    return Lesson(
      id: id,
      title: title,
      content: content,
      isCompleted: isCompleted ?? this.isCompleted,
      quizQuestions: quizQuestions,
    );
  }


  factory Lesson.fromJson(Map<String, dynamic> json) {
    print('Raw JSON before deserialization: $json');
    return Lesson(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Untitled Lesson',
      content: (json['content'] as List?)
          ?.map((c) => LessonContent.fromJson(c as Map<String, dynamic>))
          .toList() ?? [],
      isCompleted: json['isCompleted'] as bool? ?? false,
      quizQuestions: (json['quizQuestions'] as List?)
          ?.map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
          .toList() ?? [],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content.map((c) => c.toJson()).toList(),
      'isCompleted': isCompleted,
      'quizQuestions': quizQuestions.map((q) => q.toJson()),
    };
  }
}


@HiveType(typeId: 1)
class LessonContent {
  @HiveField(0)
  final String type;

  @HiveField(1)
  final String data;

  LessonContent({required this.type, required this.data});


  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': data,
    };
  }


  factory LessonContent.fromJson(Map<String, dynamic> json) {
    return LessonContent(
      type: json['type'] as String,
      data: json['data'] as String,
    );
  }
}
