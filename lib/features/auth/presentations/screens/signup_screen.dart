import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:language_app/core/theme/app_theme.dart';
import 'package:language_app/features/providers/auth_provider.dart';
import 'package:language_app/widgets/custom_text_field.dart';
import 'package:language_app/core/utils/validators.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authState = ref.watch(authProvider);

    if (authState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authState.error!)),
        );
        ref.read(authProvider.notifier).state = authState.copyWith(error: null);
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account', style: AppTheme.textTheme.displayMedium),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/welcome'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                key: const Key('email-field'),
                controller: _emailController,
                label: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                key: const Key('password-field'),
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outline),
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                key: const Key('confirm-password-field'),
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_reset),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: authState.isLoading ? null : () => _handleSignup(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: authState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Create Account', style: AppTheme.textTheme.labelLarge),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      print("Form is valid, starting sign up process");
      await ref.read(authProvider.notifier).signup(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // Add this check
      final authState = ref.read(authProvider);
      if (authState.user != null) {
        print("Sign up successful, navigating to home screen");
        GoRouter.of(context).go('/home');
      } else {
        print("Sign up failed");
      }
    } else {
      print("Form is invalid");
    }
  }
}
