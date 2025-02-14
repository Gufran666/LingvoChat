import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:language_app/features/home/presentation/screens/home_screen.dart';
import 'package:language_app/features/auth/presentations/screens/login_screen.dart';
import 'package:language_app/features/providers/auth_provider.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (authState.user != null) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
