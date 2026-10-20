import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
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

  final TextEditingController _nameController = TextEditingController(text: 'Student');
  final TextEditingController _budgetController = TextEditingController(text: '25000');

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    final repo = ref.read(repositoryProvider);
    await repo.initializeDefaultsIfNeeded();

    // Set user name
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      await repo.updateAppSettings(AppSettingsCompanion(userName: drift.Value(name)));
    }

    // Set initial budget
    final budgetPaise = CurrencyFormatter.parseToPaise(_budgetController.text) ?? 2500000;
    final now = DateTime.now();
    await repo.setMonthlyBudget(
      year: now.year,
      month: now.month,
      amountPaise: budgetPaise,
    );

    // Seed demo data so user starts with a live, beautiful dashboard
    await repo.seedDemoData();

    widget.onCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
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
                    emoji: '🎯',
                    title: 'Discipline-First Budgeting',
                    subtitle: 'Set your monthly pocket money or salary first. PocketPlan automatically calculates your "Safe Daily Spend" so you never run out of cash.',
                    color: const Color(0xFF1A365D),
                  ),

                  // Slide 2: Friends & Split Module
                  _buildSlide(
                    emoji: '🍕',
                    title: 'Fair Group Splits & Hisab',
                    subtitle: 'Paid for group dinners or trips? PocketPlan protects your personal budget—only YOUR share is counted as an expense, while what friends owe you is tracked separately.',
                    color: const Color(0xFF0D9488),
                  ),

                  // Slide 3: Parent-Friendly Reports & Setup
                  _buildSetupSlide(),
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
                          color: isSel ? AppConstants.primaryBlue : const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  // Next / Get Started Button
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < 2) {
                        _pageController.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
                      } else {
                        _completeOnboarding();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      _currentPage == 2 ? 'Get Started 🚀' : 'Next',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white),
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
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 54))),
          ),
          const SizedBox(height: 36),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupSlide() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text('Almost Ready! 🎉', style: TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
          const SizedBox(height: 6),
          const Text('Tell us your details to personalize your PocketPlan:', style: TextStyle(fontSize: 13, color: Color(0xFF475569))),
          const SizedBox(height: 24),

          // Name
          const Text('YOUR NAME', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 6),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'e.g. Aryan or Priya',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 18),

          // Pocket Money / Salary
          const Text('MONTHLY POCKET MONEY / SALARY (₹)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 6),
          TextField(
            controller: _budgetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'e.g. 25000',
              prefixText: '₹ ',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
            ),
          ),
          const SizedBox(height: 18),

          // Default Categories Preview Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Color(0xFF0D9488)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Default categories (Food, Travel, Study, Shopping, Mobile, Entertainment, Health, Savings) will be pre-configured with limits.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF334155), height: 1.3),
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
