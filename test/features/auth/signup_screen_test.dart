import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_app/features/auth/data/auth_repository.dart';
import 'package:language_app/features/auth/presentations/screens/signup_screen.dart';
import 'package:language_app/features/providers/auth_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'auth_provider_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  testWidgets('Signup shows password mismatch error', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: SignupScreen())),
    );

    // Enter mismatched passwords
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.enterText(find.byType(TextFormField).at(2), 'different456');
    await tester.tap(find.text('Create Account'));
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('Successful signup flow', (tester) async {
    final container = ProviderContainer(overrides: [
      authProvider.overrideWith((ref) => AuthNotifier(MockAuthRepository())),
    ]);

    await tester.pumpWidget(
      ProviderScope(
          parent: container,
          child: const MaterialApp(home: SignupScreen())),
    );

    // Fill valid data
    await tester.enterText(find.byKey(const Key('email-field')), 'new@user.com');
    await tester.enterText(find.byKey(const Key('password-field')), 'SecurePass123!');
    await tester.enterText(find.byKey(const Key('confirm-password-field')), 'SecurePass123!');
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);
  });
}
