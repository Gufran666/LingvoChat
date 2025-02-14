import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:language_app/core/theme/app_theme.dart';
import 'package:language_app/learning/data/lesson_model.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;

  const LessonCard({super.key, required this.lesson, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.black87,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildThumbnail(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lesson.title, style: AppTheme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    _buildContentPreview(),
                    const SizedBox(height: 8),
                    _buildProgressIndicator(),
                  ],
                ),
              ),
              _buildCompletionBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: SvgPicture.asset('assets/images/lesson.svg', width: 30),
      ),
    );
  }

  Widget _buildContentPreview() {
    final textContent = lesson.content
        .where((c) => c.type == 'text')
        .take(2)
        .map((c) => c.data)
        .join(' ');
    return Text(
      textContent,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: AppTheme.textTheme.bodyMedium?.copyWith(
        color: Colors.tealAccent,
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return LinearProgressIndicator(
      value: lesson.isCompleted ? 1.0 : 0.0,
      minHeight: 4,
      borderRadius: BorderRadius.circular(2),
      color: AppTheme.primaryColor,
      backgroundColor: Colors.deepOrange,
    );
  }

  Widget _buildCompletionBadge() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: lesson.isCompleted
          ? const Icon(Icons.check_circle,
          color: AppTheme.primaryColor, size: 28)
          : const SizedBox(width: 28),
    );
  }
}
