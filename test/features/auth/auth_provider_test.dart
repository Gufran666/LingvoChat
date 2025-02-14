import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:language_app/features/auth/data/auth_repository.dart';
import 'package:language_app/features/providers/auth_provider.dart';

@GenerateMocks([AuthRepository])
import 'auth_provider_test.mocks.dart';

class MockUser extends Mock implements User {
  @override
  String get uid => 'test-uid-123';
}

void main() {
  late MockAuthRepository mockAuthRepo;
  late AuthNotifier authNotifier;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    authNotifier = AuthNotifier(mockAuthRepo);
  });

  test('Initial state is correct', () {
    expect(authNotifier.state.isLoading, false);
    expect(authNotifier.state.error, null);
    expect(authNotifier.state.user, null);
  });

  test('Login success updates state', () async {
    final mockUser = MockUser();
    when(mockAuthRepo.signInWithEmailAndPassword('test@test.com', 'password'))
        .thenAnswer((_) async => mockUser);

    await authNotifier.login('test@test.com', 'password');

    expect(authNotifier.state.isLoading, false);
    expect(authNotifier.state.user?.uid, 'test-uid-123');
    expect(authNotifier.state.error, null);
  });

  test('Login failure shows error', () async {
    when(mockAuthRepo.signInWithEmailAndPassword(any, any))
        .thenAnswer((_) async => throw FirebaseAuthException(
      code: 'wrong-password',
      message: 'Incorrect password',
    ));

    await authNotifier.login('wrong@test.com', 'wrong');

    expect(authNotifier.state.isLoading, false);
    expect(authNotifier.state.user, null);
    expect(authNotifier.state.error, 'Incorrect password');
  });
}