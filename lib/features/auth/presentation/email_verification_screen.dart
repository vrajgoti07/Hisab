import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/auth_providers.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  final String? registeredEmail;

  const EmailVerificationScreen({super.key, this.registeredEmail});

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  Timer? _pollingTimer;
  Timer? _resendCooldownTimer;
  int _secondsRemaining = 0;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _resendCooldownTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    // Periodically check every 5 seconds if user verified their email in another tab/device
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final isVerified = await ref
          .read(authControllerProvider.notifier)
          .checkEmailVerified();
      if (isVerified && mounted) {
        _pollingTimer?.cancel();
        // Trigger authState stream refresh or parent rebuild
        ref.invalidate(authStateChangesProvider);
      }
    });
  }

  void _startCooldownTimer() {
    _resendCooldownTimer?.cancel();
    setState(() => _secondsRemaining = 30);
    _resendCooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 1) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
      }
    });
  }

  Future<void> _handleManualCheck() async {
    setState(() => _isChecking = true);
    final isVerified = await ref
        .read(authControllerProvider.notifier)
        .checkEmailVerified();
    setState(() => _isChecking = false);

    if (isVerified && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email verified successfully! Welcome to Hisab.'),
          backgroundColor: AppColors.safeGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      ref.invalidate(authStateChangesProvider);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Email not yet verified. Please tap the link sent to your inbox and try again.',
          ),
          backgroundColor: AppColors.warningAmber,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleResend() async {
    if (_secondsRemaining > 0) return;

    final success = await ref
        .read(authControllerProvider.notifier)
        .resendVerificationEmail();

    if (success && mounted) {
      _startCooldownTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Verification link resent. Please check your inbox & spam folder.',
          ),
          backgroundColor: AppColors.emerald,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (mounted) {
      final error = ref.read(authControllerProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Failed to resend email.'),
          backgroundColor: AppColors.dangerRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleSignOut() async {
    _pollingTimer?.cancel();
    _resendCooldownTimer?.cancel();
    await ref.read(authControllerProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final email = widget.registeredEmail ?? user?.email ?? 'your email';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Verify Email'),
        actions: [
          IconButton(
            tooltip: 'Sign Out',
            icon: const Icon(LucideIcons.logOut),
            onPressed: _handleSignOut,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icon Graphic
                  Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.emerald.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          LucideIcons.mailCheck,
                          size: 46,
                          color: AppColors.emerald,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'Verify Your Email Address',
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

                  // Explanation
                  Text(
                    'We sent a verification link to:\n$email\n\nPlease check your email and click the link to activate your Hisab account.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.neutralSlate,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Manual Verification Check Button
                  ElevatedButton.icon(
                    onPressed: _isChecking ? null : _handleManualCheck,
                    icon: _isChecking
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(LucideIcons.refreshCw, size: 18),
                    label: const Text(
                      'I Have Verified My Email',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emerald,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Resend Email Button with Timer
                  OutlinedButton.icon(
                    onPressed: _secondsRemaining > 0 ? null : _handleResend,
                    icon: const Icon(LucideIcons.send, size: 18),
                    label: Text(
                      _secondsRemaining > 0
                          ? 'Resend available in ${_secondsRemaining}s'
                          : 'Resend Verification Link',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sign out link
                  TextButton.icon(
                    onPressed: _handleSignOut,
                    icon: const Icon(
                      LucideIcons.logOut,
                      size: 16,
                      color: AppColors.dangerRed,
                    ),
                    label: const Text(
                      'Sign Out / Use Another Account',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dangerRed,
                      ),
                    ),
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
