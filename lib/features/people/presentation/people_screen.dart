import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/providers/app_providers.dart';
import '../../../domain/services/balance_calculator.dart';
import '../../hisab/presentation/person_hisab_screen.dart';
import '../../who_owes_whom/presentation/who_owes_whom_screen.dart';
import 'add_person_dialog.dart';

class PeopleScreen extends ConsumerWidget {
  const PeopleScreen({super.key});

  void _showAddPersonDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => const AddPersonDialog());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personsAsync = ref.watch(activePersonsStreamProvider);
    final overallBalancesAsync = ref.watch(overallBalancesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final persons = personsAsync.value ?? [];
    final balances = overallBalancesAsync.value;

    final toReceive = balances?.totalToReceivePaise ?? 0;
    final toPay = balances?.totalToPayPaise ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends & Split Hisab'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.arrowLeftRight, size: 20),
            tooltip: 'Who Owes Whom & Netting',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WhoOwesWhomScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.userPlus, size: 20),
            tooltip: 'Add Friend',
            onPressed: () => _showAddPersonDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: persons.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.emerald.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.users,
                        size: 44,
                        color: AppColors.emerald,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'No Friends Added Yet',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Add friends to split group expenses, track repayments, and manage hisab.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.neutralSlate,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: () => _showAddPersonDialog(context),
                      icon: const Icon(LucideIcons.userPlus, size: 16),
                      label: const Text('Add Friend'),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Balance Cards Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppColors.cardHeaderGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emerald.withValues(alpha: 0.22),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'TOTAL TO RECEIVE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF86EFAC),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              CurrencyFormatter.formatPaise(toReceive),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(width: 1, height: 40, color: Colors.white24),
                        Column(
                          children: [
                            const Text(
                              'TOTAL I OWE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFCA5A5),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              CurrencyFormatter.formatPaise(toPay),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Who Owes Whom Banner Shortcut
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const WhoOwesWhomScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.cardDark
                            : AppColors.teal.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? AppColors.borderDark
                              : AppColors.teal.withValues(alpha: 0.25),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            LucideIcons.arrowLeftRight,
                            color: AppColors.teal,
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'View Debt Netting & Who Owes Whom',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            LucideIcons.chevronRight,
                            size: 18,
                            color: AppColors.neutralSlate,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Friends List Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ALL FRIENDS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutralSlate,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        '${persons.length} Friends',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.neutralSlate,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Friends Cards List
                  ...persons.map((person) {
                    final pBalance = balances?.personBalances.firstWhere(
                      (b) => b.personId == person.id,
                      orElse: () => PersonBalanceResult(
                        personId: person.id,
                        personName: person.name,
                        totalTheyOweMePaise: 0,
                        totalIOweThemPaise: 0,
                        netBalancePaise: 0,
                      ),
                    );

                    final net = pBalance?.netBalancePaise ?? 0;
                    final avatarColor = Color(
                      int.parse(person.avatarColor.replaceFirst('#', '0xFF')),
                    );

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: avatarColor.withValues(alpha: 0.15),
                          child: Text(
                            person.name.isNotEmpty
                                ? person.name[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: avatarColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        title: Text(
                          person.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(
                          person.phone ?? 'Tap for hisab statement',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.neutralSlate,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              net == 0
                                  ? 'Settled'
                                  : CurrencyFormatter.formatPaise(net.abs()),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: net > 0
                                    ? AppColors.safeGreen
                                    : (net < 0
                                          ? AppColors.dangerRed
                                          : AppColors.neutralSlate),
                              ),
                            ),
                            Text(
                              net > 0
                                  ? 'owes you'
                                  : (net < 0 ? 'you owe' : 'all settled'),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: net > 0
                                    ? AppColors.safeGreen
                                    : (net < 0
                                          ? AppColors.dangerRed
                                          : AppColors.neutralSlate),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PersonHisabScreen(
                                personId: person.id,
                                personName: person.name,
                                phone: person.phone,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
