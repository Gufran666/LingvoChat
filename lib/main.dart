import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_app/features/home/presentation/screens/home_screen.dart';
import 'package:language_app/learning/data/quiz_question.dart';
import 'package:path_provider/path_provider.dart';
import 'features/auth/presentations/screens/login_screen.dart';
import 'features/auth/presentations/screens/signup_screen.dart';
import 'learning/data/lesson_model.dart';
import 'features/user_model.dart';
import 'features/auth/data/auth_wrapper.dart';
import '/chat/data/chat_message.dart';
import '/chat/data/grammer_error.dart';
import 'package:language_app/features/home/presentation/screens/splash_screen.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'package:language_app/core/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully.');

    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    print('Hive initialized successfully.');

    Hive.registerAdapter(LessonAdapter());
    Hive.registerAdapter(LessonContentAdapter());
    Hive.registerAdapter(QuizQuestionAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ChatMessageAdapter());
    Hive.registerAdapter(GrammarErrorAdapter());
    print('Hive adapters registered successfully.');

    await Hive.openBox<User>('users');
    await Hive.openBox<Lesson>('lessons');
    await Hive.openBox<QuizQuestion>('quizQuestions');
    await Hive.openBox<ChatMessage>('chatHistory');
    print('Hive boxes opened successfully.');

    runApp(const ProviderScope(child: MyApp()));
  } catch (e) {
    print('Initialization error: $e');
    runApp(const InitializationErrorApp());
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'LingvoChat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}

class InitializationErrorApp extends StatelessWidget {
  const InitializationErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'App Failed to Initialize',
                style: TextStyle(fontSize: 24, color: Colors.red),
              ),
              const SizedBox(height: 20),
              const Text('Please check your internet connection'),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => main(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
