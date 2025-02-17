import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/learning/data/lesson_model.dart';
import 'package:language_app/learning/providers/lesson_provider.dart';
import 'package:language_app/learning/data/quiz_question.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_app/core/theme/app_theme.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final Lesson lesson;

  const QuizScreen({super.key, required this.lesson});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  Map<int, int?> _userAnswers = {};

  List<QuizQuestion> get questions {

    if (widget.lesson.quizQuestions.isEmpty) {
      return [
        QuizQuestion(
          questionText: 'What is the capital of France?',
          options: ['Paris', 'London', 'Berlin', 'Rome'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          questionText: 'Which planet is known as the Red Planet?',
          options: ['Earth', 'Mars', 'Jupiter', 'Saturn'],
          correctAnswerIndex: 1,
        ),
        QuizQuestion(
          questionText: 'Who wrote "To Kill a Mockingbird"?',
          options: ['Harper Lee', 'Mark Twain', 'J.K. Rowling', 'Ernest Hemingway'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          questionText: 'What is the largest ocean on Earth?',
          options: ['Atlantic Ocean', 'Indian Ocean', 'Pacific Ocean', 'Arctic Ocean'],
          correctAnswerIndex: 2,
        ),
        QuizQuestion(
          questionText: 'What is the square root of 64?',
          options: ['6', '7', '8', '9'],
          correctAnswerIndex: 2,
        ),
        QuizQuestion(
          questionText: 'Which element has the chemical symbol "O"?',
          options: ['Oxygen', 'Gold', 'Osmium', 'Oganesson'],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          questionText: 'What year did the Titanic sink?',
          options: ['1910', '1911', '1912', '1913'],
          correctAnswerIndex: 2,
        ),
        QuizQuestion(
          questionText: 'Who painted the Mona Lisa?',
          options: ['Vincent van Gogh', 'Claude Monet', 'Pablo Picasso', 'Leonardo da Vinci'],
          correctAnswerIndex: 3,
        ),
        QuizQuestion(
          questionText: 'What is the smallest prime number?',
          options: ['0', '1', '2', '3'],
          correctAnswerIndex: 2,
        ),
        QuizQuestion(
          questionText: 'Which planet is closest to the sun?',
          options: ['Venus', 'Earth', 'Mercury', 'Mars'],
          correctAnswerIndex: 2,
        ),
      ];
    }
    return widget.lesson.quizQuestions;
  }

  @override
  Widget build(BuildContext context) {
    final isLastQuestion = _currentQuestionIndex == questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: Text('The LingvoChat Quiz'),
        backgroundColor: Colors.black,
        centerTitle: true,
        titleTextStyle: AppTheme.textTheme.displayMedium?.copyWith(color: Colors.tealAccent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          questions[_currentQuestionIndex].questionText,
                          style: AppTheme.textTheme.displayMedium?.copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: questions[_currentQuestionIndex].options.length,
                          itemBuilder: (context, index) {
                            final option = questions[_currentQuestionIndex].options[index];
                            final isSelected = _userAnswers[_currentQuestionIndex] == index;

                            return Card(
                              color: Colors.black,
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(option, style: AppTheme.textTheme.bodyMedium?.copyWith(color: Colors.deepOrange)),
                                leading: Radio<int>(
                                  value: index,
                                  groupValue: _userAnswers[_currentQuestionIndex],
                                  onChanged: (value) => setState(() => _userAnswers[_currentQuestionIndex] = value),
                                ),
                                onTap: () => setState(() => _userAnswers[_currentQuestionIndex] = index),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentQuestionIndex > 0)
                      TextButton(
                        onPressed: () => setState(() => _currentQuestionIndex--),
                        child: const Text('Previous'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          textStyle: AppTheme.textTheme.bodyMedium,
                        ),
                      ),
                    if (!isLastQuestion)
                      ElevatedButton(
                        onPressed: _userAnswers.containsKey(_currentQuestionIndex)
                            ? () => setState(() => _currentQuestionIndex++)
                            : null,
                        child: const Text('Next'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          textStyle: AppTheme.textTheme.bodyMedium,
                        ),
                      ),
                    if (isLastQuestion)
                      ElevatedButton(
                        onPressed: _userAnswers.containsKey(_currentQuestionIndex)
                            ? _submitQuiz
                            : null,
                        child: const Text('Submit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          textStyle: AppTheme.textTheme.bodyMedium,
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitQuiz() {
    int newScore = 0;
    for (int i = 0; i < questions.length; i++) {
      if (_userAnswers[i] == questions[i].correctAnswerIndex) {
        newScore++;
      }
    }

    ref.read(lessonProvider.notifier)?.updateQuizProgress(widget.lesson.id, newScore);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Results'),
        content: Text('You scored $newScore out of ${questions.length}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              textStyle: AppTheme.textTheme.labelLarge,
            ),
          )
        ],
      ),
    );
  }
}
