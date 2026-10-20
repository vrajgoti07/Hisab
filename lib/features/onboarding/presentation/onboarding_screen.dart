import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/database/app_database.dart';
import '../../../data/providers/app_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  final VoidCallback onCompleted;

  const OnboardingScreen({super.key, required this.onCompleted});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isSaving = false;

  final TextEditingController _nameController = TextEditingController(
    text: 'Student',
  );
  final TextEditingController _budgetController = TextEditingController(
    text: '25000',
  );

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);

      final repo = ref.read(repositoryProvider);
      await repo.initializeDefaultsIfNeeded();

      // Set user name
      final name = _nameController.text.trim();
      if (name.isNotEmpty) {
        await repo.updateAppSettings(
          AppSettingsCompanion(userName: drift.Value(name)),
        );
      }

      // Set initial budget
      final budgetPaise =
          CurrencyFormatter.parseToPaise(_budgetController.text) ?? 2500000;
      final now = DateTime.now();
      await repo.setMonthlyBudget(
        year: now.year,
        month: now.month,
        amountPaise: budgetPaise,
      );

      // Seed demo data so user starts with a live, beautiful dashboard
      await repo.seedDemoData();

      widget.onCompleted();
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Setup completed with note: $e'),
            backgroundColor: AppColors.emerald,
          ),
        );
        widget.onCompleted();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Page View
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  // Slide 1: Budget & Safe Daily Spend
                  _buildSlide(
                    icon: LucideIcons.shieldCheck,
                    title: 'Discipline-First Budgeting',
                    subtitle:
                        'Set your monthly pocket money or salary first. Hisab calculates your "Safe Daily Spend" so you never run out of money before month-end.',
                    color: AppColors.emerald,
                    isDark: isDark,
                  ),

                  // Slide 2: Friends & Split Module
                  _buildSlide(
                    icon: LucideIcons.users,
                    title: 'Fair Group Splits & Hisab',
                    subtitle:
                        'Paid for group outings or shared bills? Hisab protects your budget: only YOUR share counts as your expense, while friends\' shares are tracked accurately.',
                    color: AppColors.teal,
                    isDark: isDark,
                  ),

                  // Slide 3: Parent-Friendly Reports & Setup
                  _buildSetupSlide(isDark),
                ],
              ),
            ),

            // Bottom Navigation & Dot Indicators
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dots
                  Row(
                    children: List.generate(3, (index) {
                      final isSel = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        width: isSel ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isSel
                              ? AppColors.emerald
                              : (isDark
                                    ? AppColors.borderDark
                                    : const Color(0xFFCBD5E1)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  // Next / Get Started Button
                  ElevatedButton(
                    onPressed: _isSaving
                        ? null
                        : () {
                            if (_currentPage < 2) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeOut,
                              );
                            } else {
                              _completeOnboarding();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emerald,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentPage == 2 ? 'Get Started' : 'Next',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                LucideIcons.arrowRight,
                                size: 16,
                                color: Colors.white,
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.2 : 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(icon, size: 50, color: color)),
          ),
          const SizedBox(height: 36),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupSlide(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                LucideIcons.sparkles,
                color: AppColors.emerald,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Personalize Hisab',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Configure your profile to start tracking your pocket budget and friends hisab:',
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 24),

          // Name
          const Text(
            'YOUR NAME',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.neutralSlate,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'e.g. Aryan or Priya',
              prefixIcon: Icon(LucideIcons.user, size: 20),
            ),
          ),
          const SizedBox(height: 18),

          // Pocket Money / Salary
          const Text(
            'MONTHLY POCKET MONEY / SALARY (₹)',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.neutralSlate,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _budgetController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'e.g. 25000',
              prefixText: '₹ ',
              prefixIcon: Icon(LucideIcons.wallet, size: 20),
            ),
          ),
          const SizedBox(height: 20),

          // Default Categories Preview Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : const Color(0xFFEEF2F6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  LucideIcons.circleCheck,
                  color: AppColors.emerald,
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Default categories (Food, Travel, Study, Shopping, Mobile, Entertainment, Health, Savings) will be pre-configured with monthly limits.',
                    style: TextStyle(fontSize: 12, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
