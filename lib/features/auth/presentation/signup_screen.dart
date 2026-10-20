import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/auth_providers.dart';
import 'email_verification_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final success = await ref
        .read(authControllerProvider.notifier)
        .registerWithEmail(email: email, password: password, displayName: name);

    if (success && mounted) {
      // Navigate to EmailVerificationScreen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => EmailVerificationScreen(registeredEmail: email),
        ),
        (route) => false,
      );
    } else if (mounted) {
      final error = ref.read(authControllerProvider).errorMessage;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  LucideIcons.circleAlert,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(error)),
              ],
            ),
            backgroundColor: AppColors.dangerRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Get Started with Hisab',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Manage your budget, track daily spends, and split bills effortlessly.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.neutralSlate,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Registration Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.2 : 0.04,
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Full Name Field
                            TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              autofillHints: const [AutofillHints.name],
                              textInputAction: TextInputAction.next,
                              enabled: !authState.isLoading,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                hintText: 'Aryan Sharma',
                                prefixIcon: Icon(LucideIcons.user, size: 20),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Full name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              textInputAction: TextInputAction.next,
                              enabled: !authState.isLoading,
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                                hintText: 'aryan@example.com',
                                prefixIcon: Icon(LucideIcons.mail, size: 20),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                final emailRegex = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                );
                                if (!emailRegex.hasMatch(val.trim())) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              autofillHints: const [AutofillHints.newPassword],
                              textInputAction: TextInputAction.next,
                              enabled: !authState.isLoading,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Min. 6 characters',
                                prefixIcon: const Icon(
                                  LucideIcons.lock,
                                  size: 20,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? LucideIcons.eyeOff
                                        : LucideIcons.eye,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Password is required';
                                }
                                if (val.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Confirm Password Field
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              autofillHints: const [AutofillHints.newPassword],
                              textInputAction: TextInputAction.done,
                              enabled: !authState.isLoading,
                              onFieldSubmitted: (_) => _handleSignUp(),
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                hintText: 'Re-enter password',
                                prefixIcon: const Icon(
                                  LucideIcons.shieldCheck,
                                  size: 20,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? LucideIcons.eyeOff
                                        : LucideIcons.eye,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (val != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Submit Button
                            ElevatedButton(
                              onPressed: authState.isLoading
                                  ? null
                                  : _handleSignUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.emerald,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: authState.isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Text(
                                      'Create Account',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Link back to Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.neutralSlate,
                        ),
                      ),
                      TextButton(
                        onPressed: authState.isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.emerald,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
