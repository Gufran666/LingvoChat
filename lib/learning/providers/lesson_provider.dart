import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:language_app/learning/data/lesson_repository.dart';
import 'package:language_app/learning/data/lesson_model.dart';
import 'package:language_app/core/services/network_service.dart';
import 'package:language_app/core/services/connectivity_service.dart';

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final networkServiceProvider = Provider<NetworkService>((ref) {
  final _connectivity = ref.read(connectivityProvider);
  return NetworkService(_connectivity);
});
final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  final _firestore = FirebaseFirestore.instance;
  final _lessonBox = Hive.box<Lesson>('lessons');
  final _networkService = ref.read(networkServiceProvider);
  return LessonRepository(_firestore, _lessonBox, _networkService);
});

final lessonProvider = StateNotifierProvider<LessonNotifier, LessonState>((ref) {
  return LessonNotifier(ref.watch(lessonRepositoryProvider));
});

class LessonState {
  final List<Lesson> lessons;
  final bool isLoading;
  final String? error;
  final double progress;

  LessonState({
    this.lessons = const [],
    this.isLoading = false,
    this.error,
    this.progress = 0,
  });
  LessonState copyWith({
    List<Lesson>? lessons,
    bool? isLoading,
    String? error,
    double? progress,
  }) {
    return LessonState(
      lessons: lessons ?? this.lessons,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      progress: progress ?? this.progress,
    );
  }
}

class LessonNotifier extends StateNotifier<LessonState> {
  final LessonRepository _repo;

  LessonNotifier(this._repo) : super(LessonState()) {
    loadLessons();
  }

  Future<void> loadLessons() async {
    state = state.copyWith(isLoading: true);
    try {
      final lessons = await _repo.fetchLessons();
      final progress = _calculateProgress(lessons);
      state = state.copyWith(
        lessons: lessons,
        isLoading: false,
        progress: progress,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> toggleLessonCompletion(String lessonId) async {
    await _repo.markLessonCompleted(lessonId);
    final updatedLessons = state.lessons.map((lesson) {
      return lesson.id == lessonId ? lesson.copyWith(isCompleted: true) : lesson;
    }).toList();
    state = state.copyWith(
      lessons: updatedLessons,
      progress: _calculateProgress(updatedLessons),
    );
  }

  void updateQuizProgress(String lessonId, int newScore) {
    // Update the lesson with the new score or any other relevant updates
    final updatedLessons = state.lessons.map((lesson) {
      if (lesson.id == lessonId) {
        return lesson.copyWith(isCompleted: true);
      }
      return lesson;
    }).toList();
    state = state.copyWith(
      lessons: updatedLessons,
      progress: _calculateProgress(updatedLessons),
    );
  }

  double _calculateProgress(List<Lesson> lessons) {
    final completed = lessons.where((lesson) => lesson.isCompleted).length;
    return lessons.isEmpty ? 0 : completed / lessons.length;
  }
}
