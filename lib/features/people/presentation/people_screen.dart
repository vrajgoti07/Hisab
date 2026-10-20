import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
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

    final persons = personsAsync.value ?? [];
    final balances = overallBalancesAsync.value;

    final toReceive = balances?.totalToReceivePaise ?? 0;
    final toPay = balances?.totalToPayPaise ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Friends & Split Hisab'),
        backgroundColor: const Color(0xFFF6F7FB),
        actions: [
          IconButton(
            icon: const Icon(Icons.balance_rounded),
            tooltip: 'Who Owes Whom & Netting',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WhoOwesWhomScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded),
            tooltip: 'Add Friend',
            onPressed: () => _showAddPersonDialog(context),
          ),
        ],
      ),
      body: persons.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.group_outlined, size: 64, color: Color(0xFF94A3B8)),
                  const SizedBox(height: 12),
                  const Text('No friends added yet', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  const Text('Add friends to split bills, trips, and track repayments.', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddPersonDialog(context),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Add First Friend', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: AppConstants.primaryBlue),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Balance Cards Header
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1A365D), Color(0xFF0F766E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F766E).withValues(alpha: 0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('TOTAL TO RECEIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF86EFAC))),
                            const SizedBox(height: 4),
                            Text(
                              CurrencyFormatter.formatPaise(toReceive),
                              style: const TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                          ],
                        ),
                        Container(width: 1, height: 40, color: Colors.white24),
                        Column(
                          children: [
                            const Text('TOTAL I OWE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFFCA5A5))),
                            const SizedBox(height: 4),
                            Text(
                              CurrencyFormatter.formatPaise(toPay),
                              style: const TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
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
                        MaterialPageRoute(builder: (_) => const WhoOwesWhomScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2F6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.auto_awesome_rounded, color: Color(0xFF0D9488), size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'View Debt Simplification & Who Owes Whom',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded, color: Colors.grey),
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
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.8),
                      ),
                      Text('${persons.length} Friends', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
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
                    final avatarColor = Color(int.parse(person.avatarColor.replaceFirst('#', '0xFF')));

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: avatarColor.withValues(alpha: 0.15),
                          child: Text(
                            person.name.isNotEmpty ? person.name[0].toUpperCase() : '?',
                            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: avatarColor, fontSize: 16),
                          ),
                        ),
                        title: Text(person.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                        subtitle: Text(
                          person.phone ?? 'Tap for full statement & hisab',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              net == 0 ? 'Settled' : CurrencyFormatter.formatPaise(net.abs()),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: net > 0 ? const Color(0xFF10B981) : (net < 0 ? const Color(0xFFEF4444) : const Color(0xFF94A3B8)),
                              ),
                            ),
                            Text(
                              net > 0 ? 'owes you' : (net < 0 ? 'you owe' : 'all clear 🎉'),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: net > 0 ? const Color(0xFF15803D) : (net < 0 ? const Color(0xFFB91C1C) : const Color(0xFF64748B)),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPersonDialog(context),
        backgroundColor: AppConstants.primaryBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Friend', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
