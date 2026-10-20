import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/auth_providers.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handlePasswordReset() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final success = await ref
        .read(authControllerProvider.notifier)
        .sendPasswordReset(email);

    if (success && mounted) {
      setState(() => _submitted = true);
    } else if (mounted) {
      final error = ref.read(authControllerProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Failed to send reset link.'),
          backgroundColor: AppColors.dangerRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Reset Password'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: _submitted
                  ? _buildSuccessView(isDark)
                  : _buildRequestForm(isDark, authState.isLoading),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestForm(bool isDark, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.emerald.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                LucideIcons.keyRound,
                size: 38,
                color: AppColors.emerald,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Forgot Your Password?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Enter your registered email address and we'll send you a secure link to reset your password.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: AppColors.neutralSlate,
          ),
        ),
        const SizedBox(height: 28),

        // Form Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.done,
                  enabled: !isLoading,
                  onFieldSubmitted: (_) => _handlePasswordReset(),
                  decoration: const InputDecoration(
                    labelText: 'Registered Email Address',
                    hintText: 'you@example.com',
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
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading ? null : _handlePasswordReset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Send Reset Link',
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
        const SizedBox(height: 24),
        Center(
          child: TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(LucideIcons.arrowLeft, size: 16),
            label: const Text(
              'Back to Sign In',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.safeGreen.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                LucideIcons.checkCheck,
                size: 40,
                color: AppColors.safeGreen,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Reset Link Sent!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'We have sent password reset instructions to:\n${_emailController.text.trim()}\n\nPlease check your inbox and follow the link to set a new password.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: AppColors.neutralSlate,
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.emerald,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Return to Sign In',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
