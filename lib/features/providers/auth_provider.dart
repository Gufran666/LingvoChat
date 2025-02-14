import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_app/features/auth/data/auth_repository.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final User? user;

  AuthState({
    this.isLoading = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    User? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.user?.uid == user?.uid;
  }

  @override
  int get hashCode => Object.hash(isLoading, error, user?.uid);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepo;

  AuthNotifier(this._authRepo) : super(AuthState()) {
    _checkAuthStatus();
  }

  // Check current authentication status
  Future<void> _checkAuthStatus() async {
    final currentUser = _authRepo.currentUser;
    if (currentUser != null) {
      state = state.copyWith(user: currentUser);
    }
  }

  // Login method
  Future<bool> login(String email, String password) async {
    try {
      final user = await _authRepo.signInWithEmailAndPassword(email, password);
      state = state.copyWith(user: user, isLoading: false, error: null);
      return true; // Return true if login is successful
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false; // Return false if login fails
    }
  }

  // Handle authentication operation
  Future<void> _handleAuthOperation(Future<User?> operation) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final user = await operation;
      state = state.copyWith(isLoading: false, user: user);
      print("Auth Operation Successful: ${user?.uid}"); // Check if user is successfully authenticated
    } on FirebaseAuthException catch (e) {
      final errorMessage = _parseAuthError(e);
      state = state.copyWith(isLoading: false, error: errorMessage);
      print("Firebase Auth Exception: ${e.code} - ${errorMessage}"); // Ensure error is properly parsed
    } catch (e, stackTrace) {
      state = state.copyWith(
        isLoading: false,
        error: 'Something went wrong. Please try again.',
      );
      print("Unexpected Error: $e, StackTrace: $stackTrace");
    }
  }

  // Parse authentication error codes
  String _parseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'Email already registered';
      case 'network-request-failed':
        return 'Check your internet connection';
      case 'invalid-credential':
        return 'Invalid credentials';
      case 'invalid-email':
        return 'Invalid email format';
      case 'user-disabled':
        return 'User account has been disabled';
      case 'operation-not-allowed':
        return 'Operation not allowed';
      case 'reCAPTCHA':
        return 'reCAPTCHA verification failed';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      default:
        return 'Authentication failed. Please try again';
    }
  }

  Future<void> signup(String email, String password) async {
    await _handleAuthOperation(
      _authRepo.signUpWithEmailAndPassword(email, password),
    );
    // Reset error state after an unsuccessful sign-up attempt
    state = state.copyWith(error: null);
  }

  Future<void> googleSignIn() async {
    await _handleAuthOperation(_authRepo.signInWithGoogle());
    // Reset error state after an unsuccessful sign-in attempt
    state = state.copyWith(error: null);
  }

  Future<void> logout() async {
    await _authRepo.logout();
    state = AuthState();
  }

  Future<void> updateProfile({required String displayName, required String email}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await currentUser.updateDisplayName(displayName);
        await currentUser.updateEmail(email);
        await currentUser.reload();
        final updatedUser = FirebaseAuth.instance.currentUser;
        state = state.copyWith(isLoading: false, user: updatedUser);
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = _parseAuthError(e);
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update profile. Please try again.',
      );
    }
  }
}

// Provider for AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
