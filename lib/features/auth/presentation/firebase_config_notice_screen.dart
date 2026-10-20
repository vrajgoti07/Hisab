import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

/// Screen displayed when Firebase is not yet configured or fails initialization.
/// Provides actionable guidance, configuration documentation instructions, and a retry action.
class FirebaseConfigNoticeScreen extends StatelessWidget {
  final Object? error;
  final VoidCallback onRetry;
  final VoidCallback onContinueWithDemo;

  const FirebaseConfigNoticeScreen({
    super.key,
    required this.error,
    required this.onRetry,
    required this.onContinueWithDemo,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: AppColors.warningAmber.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        LucideIcons.flame,
                        size: 40,
                        color: AppColors.warningAmber,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Firebase Configuration Required',
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
                  Text(
                    'Firebase credentials were not found for this platform. To connect real Firebase Authentication, register the application and download your configuration file.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: AppColors.neutralSlate,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Guidance Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              LucideIcons.fileCode,
                              size: 18,
                              color: AppColors.emerald,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Setup Checklist',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '1. Create a project at console.firebase.google.com\n'
                          '2. Register Android app (com.pocketplan.app.pocketplan)\n'
                          '3. Download google-services.json to android/app/\n'
                          '4. Or run: flutterfire configure\n'
                          '5. Enable Email/Password and Google sign-in',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.6,
                            fontFamily: 'monospace',
                          ),
                        ),
                        if (error != null) ...[
                          const Divider(height: 24),
                          Text(
                            'Diagnostic details: $error',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Actions
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(LucideIcons.refreshCw, size: 18),
                    label: const Text('Retry Firebase Initialization'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emerald,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: onContinueWithDemo,
                    icon: const Icon(LucideIcons.playCircle, size: 18),
                    label: const Text('Continue with Local Demo Auth'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
