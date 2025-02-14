import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:language_app/core/theme/app_theme.dart';
import 'package:language_app/learning/data/lesson_model.dart';
import 'package:language_app/learning/providers/lesson_provider.dart';

class LessonDetailScreen extends ConsumerStatefulWidget {
  final Lesson lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  ConsumerState<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends ConsumerState<LessonDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title, style: AppTheme.textTheme.displayMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => ref.read(lessonProvider.notifier)
                .toggleLessonCompletion(widget.lesson.id),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          ...widget.lesson.content.map(_buildContentItem),
        ],
      ),
    );
  }

  Widget _buildContentItem(LessonContent content) {
    switch (content.type) {
      case 'text':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            content.data,
            style: AppTheme.textTheme.bodyLarge,
          ),
        );
      case 'audio':
        return _AudioPlayerWidget(
          url: content.data,
          player: _audioPlayer,
        );
      case 'image':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(imageUrl: content.data),
          ),
        );
      default:
        return const SizedBox();
    }
  }
}

class _AudioPlayerWidget extends StatefulWidget {
  final String url;
  final AudioPlayer player;

  const _AudioPlayerWidget({required this.url, required this.player});

  @override
  State<_AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<_AudioPlayerWidget> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: IconButton(
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: _togglePlay,
        ),
        title: const Text('Listen to Pronunciation'),
        trailing: _isPlaying
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(),
        )
            : null,
      ),
    );
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await widget.player.pause();
    } else {
      await widget.player.setUrl(widget.url);
      await widget.player.play();
    }
    setState(() => _isPlaying = !_isPlaying);
  }
}
