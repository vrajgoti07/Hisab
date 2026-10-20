import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/database/app_database.dart';
import '../../../data/providers/app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showEditNameDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Edit Your Name'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Display Name',
              hintText: 'e.g. Aryan or Priya',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  final repo = ref.read(repositoryProvider);
                  await repo.updateAppSettings(
                    AppSettingsCompanion(userName: drift.Value(name)),
                  );
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmClearData(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Clear All Demo / User Data?'),
          content: const Text(
            'This will reset all expenses, split bills, and hisab entries. Categories will be preserved.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dangerRed,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final repo = ref.read(repositoryProvider);
                await repo.clearAllData();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All demo and transaction data cleared.'),
                    ),
                  );
                }
              },
              child: const Text('Clear All Data'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettingsAsync = ref.watch(appSettingsStreamProvider);
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userName = appSettingsAsync.value?.userName ?? 'Student';

    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Preferences')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Profile Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.emerald.withValues(alpha: 0.15),
                  child: const Icon(
                    LucideIcons.user,
                    size: 26,
                    color: AppColors.emerald,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Hisab Personal Account',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Edit name',
                  icon: const Icon(
                    LucideIcons.pencil,
                    size: 18,
                    color: AppColors.emerald,
                  ),
                  onPressed: () => _showEditNameDialog(context, ref, userName),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Appearance Section
          const Text(
            'APPEARANCE & THEME',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.neutralSlate,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.palette,
                        size: 20,
                        color: AppColors.emerald,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Theme Mode',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        currentThemeMode == ThemeMode.dark
                            ? 'Dark'
                            : (currentThemeMode == ThemeMode.light
                                  ? 'Light'
                                  : 'System'),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutralSlate,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Light'),
                        icon: Icon(LucideIcons.sun, size: 16),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('Dark'),
                        icon: Icon(LucideIcons.moon, size: 16),
                      ),
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('System'),
                        icon: Icon(LucideIcons.sparkles, size: 16),
                      ),
                    ],
                    selected: {currentThemeMode},
                    onSelectionChanged: (selected) {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(selected.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Database & Demo Data
          const Text(
            'DATA & STORAGE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.neutralSlate,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    LucideIcons.sparkles,
                    size: 20,
                    color: AppColors.teal,
                  ),
                  title: const Text(
                    'Seed Sample Demo Data',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Populate current month with sample expenses and 4 friends hisab',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(LucideIcons.chevronRight, size: 18),
                  onTap: () async {
                    final repo = ref.read(repositoryProvider);
                    await repo.seedDemoData();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sample demo data loaded! 🎉'),
                          backgroundColor: AppColors.emerald,
                        ),
                      );
                    }
                  },
                ),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
                ListTile(
                  leading: const Icon(
                    LucideIcons.trash2,
                    size: 20,
                    color: AppColors.dangerRed,
                  ),
                  title: const Text(
                    'Clear All Demo & User Data',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.dangerRed,
                    ),
                  ),
                  subtitle: const Text(
                    'Reset all expenses, settlements, and hisab entries',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(LucideIcons.chevronRight, size: 18),
                  onTap: () => _confirmClearData(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About App
          const Text(
            'ABOUT HISAB',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.neutralSlate,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    LucideIcons.info,
                    size: 20,
                    color: AppColors.emerald,
                  ),
                  title: const Text(
                    'Hisab',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Version 2.0.0 • Modern Indian Budgeting & Group Expense Hisab',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
                ListTile(
                  leading: const Icon(
                    LucideIcons.shieldCheck,
                    size: 20,
                    color: AppColors.safeGreen,
                  ),
                  title: const Text(
                    '100% Private & Offline-First',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'All calculations run locally on your phone SQLite database. No external trackers or cloud servers.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
