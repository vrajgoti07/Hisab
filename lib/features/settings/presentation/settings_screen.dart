import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/database/app_database.dart';
import '../../../data/providers/app_providers.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showEditNameDialog(BuildContext context, WidgetRef ref, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Edit Your Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Name (Used in Reports)'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  final repo = ref.read(repositoryProvider);
                  await repo.updateAppSettings(AppSettingsCompanion(userName: drift.Value(name)));
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
          content: const Text('This will reset all expenses, split bills, and hisab entries. Categories will be preserved.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
              onPressed: () async {
                final repo = ref.read(repositoryProvider);
                await repo.clearAllData();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All demo data cleared.')),
                  );
                }
              },
              child: const Text('Clear All Data', style: TextStyle(color: Colors.white)),
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
    final userName = appSettingsAsync.value?.userName ?? 'Student';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Settings & Preferences'),
        backgroundColor: const Color(0xFFF6F7FB),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFF0D9488),
                  child: Icon(Icons.person, size: 28, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userName, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 16)),
                      const Text('PocketPlan Student Account', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Color(0xFF0D9488)),
                  onPressed: () => _showEditNameDialog(context, ref, userName),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Appearance Section
          const Text('APPEARANCE & THEME', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFE2E8F0))),
            child: ListTile(
              leading: const Icon(Icons.palette_outlined, color: Color(0xFF3B82F6)),
              title: const Text('Theme Mode', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(currentThemeMode == ThemeMode.dark ? 'Dark Mode' : 'Light Mode'),
              trailing: Switch(
                value: currentThemeMode == ThemeMode.dark,
                activeThumbColor: const Color(0xFF3B82F6),
                onChanged: (isDark) {
                  ref.read(themeModeProvider.notifier).state = isDark ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Demo Data & Management
          const Text('DATABASE & DEMO DATA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFE2E8F0))),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.auto_fix_high_rounded, color: Color(0xFF0D9488)),
                  title: const Text('Seed Sample Demo Data', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Load 1 month of sample expenses & 4 friends hisab'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () async {
                    final repo = ref.read(repositoryProvider);
                    await repo.seedDemoData();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sample demo data loaded! 🎉'), backgroundColor: Color(0xFF0D9488)),
                      );
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
                  title: const Text('Clear All Demo / User Data', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFEF4444))),
                  subtitle: const Text('Reset expense and split history'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _confirmClearData(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // About App
          const Text('ABOUT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFE2E8F0))),
            child: const Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline_rounded, color: Color(0xFF1A365D)),
                  title: Text('PocketPlan', style: TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('Version 2.0.0 • Offline-First Personal Finance & Splitwise Engine'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.lock_outline_rounded, color: Color(0xFF10B981)),
                  title: Text('100% Private & Offline', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('No cloud servers, no trackers. All data stays in your phone SQLite database.'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
