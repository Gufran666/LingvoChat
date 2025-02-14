import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:language_app/learning/data/lesson_model.dart';
import 'package:language_app/core/services/network_service.dart';
import 'package:language_app/core/services/connectivity_service.dart';

class LessonRepository {
  final FirebaseFirestore _firestore;
  final Box<Lesson> _lessonBox;
  final NetworkService _networkService;

  LessonRepository(this._firestore, this._lessonBox, this._networkService);

  Future<List<Lesson>> fetchLessons() async {
    if (await _networkService.isConnected) {
      final snapshot = await _firestore.collection('lessons').get();
      print('Fetched data: ${snapshot.docs.map((doc) => doc.data()).toList()}'); // Log fetched data

      // Additional logging to check data types
      for (var doc in snapshot.docs) {
        var data = doc.data();
        print("Fetched Firestore Data: ${data}");

        print("Type of 'id': ${data['id']?.runtimeType}");
        print("Type of 'title': ${data['title']?.runtimeType}");
        print("Type of 'content': ${data['content']?.runtimeType}");
        print("Type of 'isCompleted': ${data['isCompleted']?.runtimeType}");
        print("Type of 'quizQuestions': ${data['quizQuestions']?.runtimeType}");
      }

      final lessons = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        print('Processing document: $data'); // Log each document

        // Ensure to handle potential null values
        return Lesson.fromJson(data);
      }).toList();
      await _saveLessonsToLocalCache(lessons);
      return lessons;
    } else {
      return _loadLessonsFromLocalCache();
    }
  }

  Future<void> _saveLessonsToLocalCache(List<Lesson> lessons) async {
    await _lessonBox.clear();
    for (var lesson in lessons) {
      await _lessonBox.put(lesson.id, lesson);
    }
  }

  List<Lesson> _loadLessonsFromLocalCache() {
    return _lessonBox.values.toList();
  }

  Future<void> markLessonCompleted(String lessonId) async {
    final lesson = _lessonBox.get(lessonId);
    if (lesson != null) {
      final updatedLesson = lesson.copyWith(isCompleted: true);
      await _lessonBox.put(lessonId, updatedLesson);
    }
  }
}
