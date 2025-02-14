import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_app/features/auth/data/auth_repository.dart';
import 'package:language_app/features/auth/presentations/screens/login_screen.dart';
import 'package:language_app/features/providers/auth_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'login_screen_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  testWidgets('Login Screen shows validation errors', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );

    // Tap login without input
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    expect(find.text('Email required'), findsOneWidget);
    expect(find.text('Password required'), findsOneWidget);
  });

  testWidgets('Successful login navigation', (tester) async {
    // Mock auth provider
    final container = ProviderContainer(overrides: [
      authProvider.overrideWith((ref) => AuthNotifier(MockAuthRepository())),
    ]);

    await tester.pumpWidget(
      ProviderScope(
        parent: container,
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    // Enter valid credentials
    await tester.enterText(find.byKey(const Key('email-field')), 'test@test.com');
    await tester.enterText(find.byKey(const Key('password-field')), 'password123');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    // Verify home screen appears
    expect(find.text('Welcome'), findsOneWidget);
  });
}
