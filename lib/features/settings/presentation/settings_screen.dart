import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showEditPersonalAccountDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
    String? currentEmail,
    String? phone,
  ) {
    final nameController = TextEditingController(text: currentName);
    final emailController = TextEditingController(text: currentEmail ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Personal Account Details'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Link your personal email address and update your account details.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.neutralSlate,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (phone != null && phone.isNotEmpty) ...[
                    TextFormField(
                      initialValue: '+91 $phone',
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Verified Phone Number',
                        prefixIcon: Icon(
                          LucideIcons.phone,
                          size: 18,
                          color: AppColors.safeGreen,
                        ),
                        suffixIcon: Icon(
                          LucideIcons.checkCircle2,
                          size: 18,
                          color: AppColors.safeGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Display Name',
                      hintText: 'e.g. Aryan or Priya',
                      prefixIcon: Icon(LucideIcons.user, size: 18),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please enter a name'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'e.g. aryan@gmail.com',
                      prefixIcon: Icon(LucideIcons.mail, size: 18),
                    ),
                    validator: (v) {
                      if (v != null && v.trim().isNotEmpty) {
                        final emailRegex = RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        );
                        if (!emailRegex.hasMatch(v.trim())) {
                          return 'Enter a valid email address';
                        }
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final name = nameController.text.trim();
                  final email = emailController.text.trim();

                  await ref
                      .read(authNotifierProvider.notifier)
                      .updatePersonalAccount(name: name, email: email);

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Personal account details updated successfully!',
                        ),
                        backgroundColor: AppColors.safeGreen,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              child: const Text('Save Details'),
            ),
          ],
        );
      },
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref, String? email) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Log Out of Hisab?'),
          content: Text(
            email != null && email.isNotEmpty
                ? 'Are you sure you want to log out from $email? You will need your password or Google account to sign back in.'
                : 'Are you sure you want to log out? You will need your credentials to sign back in.',
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
                await ref.read(authNotifierProvider.notifier).logout();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logged out successfully.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('Log Out'),
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
                      behavior: SnackBarBehavior.floating,
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
    final authState = ref.watch(authNotifierProvider);
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final userName =
        authState.userName ?? (appSettingsAsync.value?.userName ?? 'Student');
    final phone = authState.phoneNumber;
    final email = authState.email;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Preferences')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Personal Account Profile Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.emerald.withValues(
                        alpha: 0.15,
                      ),
                      child: Text(
                        userName.isNotEmpty
                            ? userName.substring(0, 1).toUpperCase()
                            : 'H',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emerald,
                        ),
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
                          Row(
                            children: [
                              Text(
                                email != null && email.isNotEmpty
                                    ? email
                                    : (phone != null && phone.isNotEmpty
                                          ? '+91 $phone'
                                          : 'Authenticated User'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.textMutedDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                              if (authState.isEmailVerified ||
                                  authState.isGoogleUser) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.safeGreen.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Verified',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.safeGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Edit Personal Account',
                      icon: const Icon(
                        LucideIcons.pencil,
                        size: 18,
                        color: AppColors.emerald,
                      ),
                      onPressed: () => _showEditPersonalAccountDialog(
                        context,
                        ref,
                        userName,
                        email,
                        phone,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(
                  height: 1,
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
                const SizedBox(height: 12),

                // Linked Email Row
                InkWell(
                  onTap: () => _showEditPersonalAccountDialog(
                    context,
                    ref,
                    userName,
                    email,
                    phone,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.mail,
                          size: 16,
                          color: (email != null && email.isNotEmpty)
                              ? AppColors.teal
                              : AppColors.warningAmber,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            (email != null && email.isNotEmpty)
                                ? email
                                : 'No email added (Tap to link email)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: (email != null && email.isNotEmpty)
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              color: (email != null && email.isNotEmpty)
                                  ? (isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight)
                                  : AppColors.warningAmber,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: (email != null && email.isNotEmpty)
                                ? AppColors.teal.withValues(alpha: 0.12)
                                : AppColors.warningAmber.withValues(
                                    alpha: 0.12,
                                  ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            (email != null && email.isNotEmpty)
                                ? 'Linked'
                                : '+ Add Email',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: (email != null && email.isNotEmpty)
                                  ? AppColors.teal
                                  : AppColors.warningAmber,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                        currentThemeMode == ThemeMode.light
                            ? 'Light'
                            : (currentThemeMode == ThemeMode.dark
                                  ? 'Dark'
                                  : 'System'),
                        style: const TextStyle(
                          fontSize: 12,
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
                        icon: Icon(LucideIcons.smartphone, size: 16),
                      ),
                    ],
                    selected: {currentThemeMode},
                    onSelectionChanged: (newSelection) {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(newSelection.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Data Management
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
                    LucideIcons.database,
                    size: 20,
                    color: AppColors.emerald,
                  ),
                  title: const Text(
                    'Load Demo & Sample Data',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Populate sample expenses, categories, and friends for testing',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    LucideIcons.chevronRight,
                    size: 18,
                    color: AppColors.neutralSlate,
                  ),
                  onTap: () async {
                    final repo = ref.read(repositoryProvider);
                    await repo.seedDemoData();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Sample demo data loaded successfully!',
                          ),
                          behavior: SnackBarBehavior.floating,
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
                    'Clear All Transaction Data',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.dangerRed,
                    ),
                  ),
                  subtitle: const Text(
                    'Reset expenses, split bills, and person hisab records',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    LucideIcons.chevronRight,
                    size: 18,
                    color: AppColors.neutralSlate,
                  ),
                  onTap: () => _confirmClearData(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // App Info Section
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
          const SizedBox(height: 24),

          // Account Actions Section
          const Text(
            'ACCOUNT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.neutralSlate,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(
                LucideIcons.logOut,
                size: 20,
                color: AppColors.dangerRed,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.dangerRed,
                ),
              ),
              subtitle: Text(
                email != null && email.isNotEmpty
                    ? 'Logged in as $email'
                    : 'Sign out of this session',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: const Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: AppColors.neutralSlate,
              ),
              onTap: () => _confirmLogout(context, ref, email),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
