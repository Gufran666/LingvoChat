import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/core/theme/app_theme.dart';
import 'package:language_app/learning/data/lesson_model.dart';
import 'package:language_app/learning/presentation/widgets/lesson_card.dart';
import 'package:language_app/learning/providers/lesson_provider.dart';
import 'package:language_app/learning/presentation/screens/lesson_detail_screen.dart';

class LessonsScreen extends ConsumerWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lessonProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: Text('Language Lessons', style: AppTheme.textTheme.displayMedium),
        actions: [
          _ProgressIndicator(state.progress),
        ],
      ),
      body: _buildContent(context, state),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/translate');
        },
        backgroundColor: AppTheme.secondaryColor,
        child: const Icon(Icons.translate),
      ),
    );
  }

  Widget _buildContent(BuildContext context, LessonState state) {
    if (state.isLoading) return const Center(child: CircularProgressIndicator());
    if (state.error != null) return Center(child: Text(state.error!));

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.lessons.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, index) {
        final lesson = state.lessons[index];


        print('Displaying lesson: ${lesson.toJson()}');


        return LessonCard(
          lesson: Lesson(
            id: lesson.id,
            title: lesson.title, // Handle potential null title
            content: lesson.content.isNotEmpty ? lesson.content : [LessonContent(type: 'text', data: 'No content available')],
            isCompleted: lesson.isCompleted,
            quizQuestions: lesson.quizQuestions.isNotEmpty ? lesson.quizQuestions : [],
          ),
          onTap: () => _navigateToLessonDetail(context, lesson),
        );
      },
    );
  }

  void _navigateToLessonDetail(BuildContext context, Lesson lesson) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => LessonDetailScreen(lesson: lesson),
    ));
  }
}

class _ProgressIndicator extends StatelessWidget {
  final double progress;

  const _ProgressIndicator(this.progress);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 2,
            color: AppTheme.primaryColor,
          ),
          Text('${(progress * 100).toInt()}%',
            style: AppTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
