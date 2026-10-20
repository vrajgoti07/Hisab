import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/expenses/presentation/add_edit_expense_sheet.dart';
import '../features/expenses/presentation/expenses_screen.dart';
import '../features/people/presentation/people_screen.dart';
import '../features/reports/presentation/reports_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ExpensesScreen(),
    PeopleScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  void _showAddExpenseModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddEditExpenseSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseModal,
        tooltip: 'Add new expense',
        backgroundColor: AppColors.emerald,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(LucideIcons.plus, size: 24),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
          indicatorColor: AppColors.emerald.withValues(
            alpha: isDark ? 0.25 : 0.12,
          ),
          elevation: 0,
          destinations: const [
            NavigationDestination(
              icon: Icon(LucideIcons.layoutDashboard, size: 20),
              selectedIcon: Icon(
                LucideIcons.layoutDashboard,
                size: 20,
                color: AppColors.emerald,
              ),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.receiptText, size: 20),
              selectedIcon: Icon(
                LucideIcons.receiptText,
                size: 20,
                color: AppColors.emerald,
              ),
              label: 'Expenses',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.users, size: 20),
              selectedIcon: Icon(
                LucideIcons.users,
                size: 20,
                color: AppColors.emerald,
              ),
              label: 'Friends',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.chartColumnBig, size: 20),
              selectedIcon: Icon(
                LucideIcons.chartColumnBig,
                size: 20,
                color: AppColors.emerald,
              ),
              label: 'Reports',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.settings, size: 20),
              selectedIcon: Icon(
                LucideIcons.settings,
                size: 20,
                color: AppColors.emerald,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
