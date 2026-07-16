import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_text_field.dart';
import 'auth_notifier.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email wajib diisi';
    }

    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailPattern.hasMatch(email)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Password wajib diisi';
    }

    if (password.length < 8) {
      return 'Password minimal 8 karakter';
    }

    return null;
  }

  Future<void> _handleSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    try {
      final response = await ref
          .read(authNotifierProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      context.go('/home');
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).loading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Container(
                height: 78,
                width: 78,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: AppTheme.primaryColor,
                  size: 40,
                ),
              ),
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.black.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Masuk untuk melanjutkan belajar di LMS Adhivasindo.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black.withValues(alpha: 0.48),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              AppCard(
                padding: const EdgeInsets.all(22),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_rounded,
                        validator: _validateEmail,
                        readOnly: isLoading,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: true,
                        prefixIcon: Icons.lock_rounded,
                        validator: _validatePassword,
                        readOnly: isLoading,
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        text: isLoading ? 'Signing In...' : 'Sign In',
                        onPressed: isLoading ? null : _handleSubmit,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
