import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../../core/utils/date_formatter.dart';
import '../../domain/services/balance_calculator.dart';
import '../../domain/services/budget_status_calculator.dart';
import '../../domain/services/debt_simplifier.dart';
import '../database/app_database.dart';
import '../repositories/pocketplan_repository.dart';
import '../../features/auth/models/app_user.dart';
import '../../features/auth/models/auth_state.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../features/auth/services/auth_service.dart';

// SharedPreferences Provider (can be overridden in ProviderScope)
final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) => null);

// Reactive ThemeMode Provider that syncs with SharedPreferences and DB
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences? _prefs;
  final PocketPlanRepository _repo;

  ThemeModeNotifier(this._prefs, this._repo) : super(ThemeMode.light) {
    _loadInitialTheme();
  }

  void _loadInitialTheme() {
    final saved = _prefs?.getString('app_theme_mode');
    if (saved == 'dark') {
      state = ThemeMode.dark;
    } else if (saved == 'system') {
      state = ThemeMode.system;
    } else {
      state = ThemeMode.light;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final modeString = mode == ThemeMode.dark
        ? 'dark'
        : (mode == ThemeMode.system ? 'system' : 'light');
    await _prefs?.setString('app_theme_mode', modeString);
    try {
      await _repo.updateAppSettings(
        AppSettingsCompanion(themeMode: drift.Value(modeString)),
      );
    } catch (_) {}
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final repo = ref.watch(repositoryProvider);
  return ThemeModeNotifier(prefs, repo);
});

// Database Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// Repository Provider
final repositoryProvider = Provider<PocketPlanRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return PocketPlanRepository(db);
});

// Authentication State Notifier backed by Firebase Authentication
class AuthNotifier extends StateNotifier<AuthState> {
  final BaseAuthService _authService;
  final PocketPlanRepository _repo;
  final SharedPreferences? _prefs;
  StreamSubscription<AppUser?>? _subscription;

  AuthNotifier(this._authService, this._repo, this._prefs)
    : super(const AuthState()) {
    _init();
  }

  void _init() {
    final current = _authService.currentUser;
    if (current != null) {
      _applyUser(current);
    }
    _subscription = _authService.authStateChanges.listen((user) {
      _applyUser(user);
    });
  }

  void _applyUser(AppUser? user) {
    if (user == null) {
      state = const AuthState(isLoggedIn: false);
      return;
    }

    final localName = _prefs?.getString('auth_user_name');
    final name = (user.displayName != null && user.displayName!.isNotEmpty)
        ? user.displayName!
        : (localName ?? 'Student');

    state = AuthState(
      isLoggedIn: user.canAccessApp,
      uid: user.uid,
      email: user.email,
      userName: name,
      photoUrl: user.photoUrl,
      isEmailVerified: user.isEmailVerified,
      isGoogleUser: user.isGoogleUser,
    );
  }

  Future<void> updatePersonalAccount({
    required String name,
    required String email,
  }) async {
    final trimmedName = name.trim();
    final trimmedEmail = email.trim();

    await _prefs?.setString('auth_user_name', trimmedName);
    await _prefs?.setString('auth_user_email', trimmedEmail);

    try {
      await _authService.updateDisplayName(trimmedName);
    } catch (_) {}

    try {
      await _repo.updateAppSettings(
        AppSettingsCompanion(userName: drift.Value(trimmedName)),
      );
    } catch (_) {}

    state = state.copyWith(userName: trimmedName, email: trimmedEmail);
  }

  Future<void> logout() async {
    await _authService.signOut();
    state = const AuthState(isLoggedIn: false);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final authService = ref.watch(authServiceProvider);
  final repo = ref.watch(repositoryProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthNotifier(authService, repo, prefs);
});

// Active Month & Year Selection Provider

class ActiveMonthYear {
  final int year;
  final int month;

  const ActiveMonthYear({required this.year, required this.month});

  ActiveMonthYear copyWith({int? year, int? month}) {
    return ActiveMonthYear(year: year ?? this.year, month: month ?? this.month);
  }

  ActiveMonthYear previousMonth() {
    if (month == 1) {
      return ActiveMonthYear(year: year - 1, month: 12);
    } else {
      return ActiveMonthYear(year: year, month: month - 1);
    }
  }

  ActiveMonthYear nextMonth() {
    if (month == 12) {
      return ActiveMonthYear(year: year + 1, month: 1);
    } else {
      return ActiveMonthYear(year: year, month: month + 1);
    }
  }

  String get displayName => '${DateFormatter.getMonthName(month)} $year';
}

final activeMonthYearProvider = StateProvider<ActiveMonthYear>((ref) {
  final now = DateTime.now();
  return ActiveMonthYear(year: now.year, month: now.month);
});

// App Settings Stream
final appSettingsStreamProvider = StreamProvider<AppSetting?>((ref) {
  final repo = ref.watch(repositoryProvider);
  return repo.watchAppSettings();
});

// Active Categories Stream
final activeCategoriesStreamProvider = StreamProvider<List<Category>>((ref) {
  final repo = ref.watch(repositoryProvider);
  return repo.watchActiveCategories();
});

// Active Persons / Friends Stream
final activePersonsStreamProvider = StreamProvider<List<Person>>((ref) {
  final repo = ref.watch(repositoryProvider);
  return repo.watchActivePersons();
});

// Monthly Budget Stream for Active Month
final activeMonthlyBudgetStreamProvider = StreamProvider<MonthlyBudget?>((ref) {
  final repo = ref.watch(repositoryProvider);
  final activeMY = ref.watch(activeMonthYearProvider);
  return repo.watchMonthlyBudget(activeMY.year, activeMY.month);
});

// Monthly Expenses Stream for Active Month
final activeMonthlyExpensesStreamProvider = StreamProvider<List<Expense>>((
  ref,
) {
  final repo = ref.watch(repositoryProvider);
  final activeMY = ref.watch(activeMonthYearProvider);
  return repo.watchExpensesForMonth(activeMY.year, activeMY.month);
});

// Split Expenses Stream
final splitExpensesStreamProvider = StreamProvider<List<SplitExpense>>((ref) {
  final repo = ref.watch(repositoryProvider);
  return repo.watchSplitExpenses();
});

// Split Shares Stream
final splitSharesStreamProvider = StreamProvider<List<SplitShare>>((ref) {
  final repo = ref.watch(repositoryProvider);
  return repo.watchAllSplitShares();
});

// Settlements Stream
final settlementsStreamProvider = StreamProvider<List<Settlement>>((ref) {
  final repo = ref.watch(repositoryProvider);
  return repo.watchSettlements();
});

// Savings Goals Stream
final savingsGoalsStreamProvider = StreamProvider<List<SavingsGoal>>((ref) {
  final repo = ref.watch(repositoryProvider);
  return repo.watchSavingsGoals();
});

// Distinct Where Spent Autocomplete
final distinctWhereSpentProvider = FutureProvider<List<String>>((ref) {
  final repo = ref.watch(repositoryProvider);
  return repo.getDistinctWhereSpent();
});

// ----------------------------------------------------------------------------
// COMPUTED / DERIVED DASHBOARD SUMMARY PROVIDER
// ----------------------------------------------------------------------------

class DashboardState {
  final MonthBudgetSummary monthSummary;
  final List<CategoryBudgetSummary> categorySummaries;
  final List<Expense> top5Expenses;
  final List<Expense> recentExpenses;
  final int daysUnderSafeDailySpendCount;

  const DashboardState({
    required this.monthSummary,
    required this.categorySummaries,
    required this.top5Expenses,
    required this.recentExpenses,
    required this.daysUnderSafeDailySpendCount,
  });
}

final dashboardStateProvider = Provider<AsyncValue<DashboardState>>((ref) {
  final activeMY = ref.watch(activeMonthYearProvider);
  final budgetAsync = ref.watch(activeMonthlyBudgetStreamProvider);
  final expensesAsync = ref.watch(activeMonthlyExpensesStreamProvider);
  final categoriesAsync = ref.watch(activeCategoriesStreamProvider);

  if (budgetAsync.isLoading ||
      expensesAsync.isLoading ||
      categoriesAsync.isLoading) {
    return const AsyncValue.loading();
  }

  if (budgetAsync.hasError) {
    return AsyncValue.error(budgetAsync.error!, budgetAsync.stackTrace!);
  }
  if (expensesAsync.hasError) {
    return AsyncValue.error(expensesAsync.error!, expensesAsync.stackTrace!);
  }
  if (categoriesAsync.hasError) {
    return AsyncValue.error(
      categoriesAsync.error!,
      categoriesAsync.stackTrace!,
    );
  }

  final budget = budgetAsync.value;
  final expenses = expensesAsync.value ?? [];
  final categories = categoriesAsync.value ?? [];

  final budgetPaise =
      budget?.amountPaise ?? 2500000; // Default ₹25k if not configured
  final carriedPaise = budget?.carriedAmountPaise ?? 0;

  // Total personal spent = sum of expenses
  final totalSpentPaise = expenses.fold<int>(
    0,
    (sum, e) => sum + e.amountPaise,
  );

  final daysInMonth = DateFormatter.getDaysInMonth(
    activeMY.year,
    activeMY.month,
  );
  final daysLeft = DateFormatter.getDaysRemaining(
    activeMY.year,
    activeMY.month,
  );
  final now = DateTime.now();
  final daysElapsed = (activeMY.year == now.year && activeMY.month == now.month)
      ? now.day
      : (activeMY.year < now.year ||
                (activeMY.year == now.year && activeMY.month < now.month)
            ? daysInMonth
            : 1);

  final monthSummary = BudgetStatusCalculator.computeMonthlySummary(
    budgetPaise: budgetPaise,
    carriedAmountPaise: carriedPaise,
    totalPersonalSpentPaise: totalSpentPaise,
    daysInMonth: daysInMonth,
    daysLeftInMonth: daysLeft,
    daysElapsedInMonth: daysElapsed,
  );

  // Category Summaries
  final Map<int, int> catSpendMap = {};
  for (final exp in expenses) {
    catSpendMap[exp.categoryId] =
        (catSpendMap[exp.categoryId] ?? 0) + exp.amountPaise;
  }

  final List<CategoryBudgetSummary> catSummaries = [];
  for (final cat in categories) {
    final spent = catSpendMap[cat.id] ?? 0;
    catSummaries.add(
      BudgetStatusCalculator.computeCategorySummary(
        categoryId: cat.id,
        categoryName: cat.name,
        emoji: cat.emoji,
        colorHex: cat.colorHex,
        limitPaise: cat.monthlyLimitPaise,
        spentPaise: spent,
      ),
    );
  }

  // Top 5 Expenses
  final sortedExpenses = List<Expense>.from(expenses)
    ..sort((a, b) => b.amountPaise.compareTo(a.amountPaise));
  final top5 = sortedExpenses.take(5).toList();

  // Streak Count: count of expenses that were <= safeDailySpend
  final safeDaily = monthSummary.safeDailySpendPaise;
  final streak = expenses.where((e) => e.amountPaise <= safeDaily).length;

  return AsyncValue.data(
    DashboardState(
      monthSummary: monthSummary,
      categorySummaries: catSummaries,
      top5Expenses: top5,
      recentExpenses: expenses.take(10).toList(),
      daysUnderSafeDailySpendCount: streak,
    ),
  );
});

// ----------------------------------------------------------------------------
// BALANCES & HISAB PROVIDER
// ----------------------------------------------------------------------------

final overallBalancesProvider = Provider<AsyncValue<OverallBalancesResult>>((
  ref,
) {
  final personsAsync = ref.watch(activePersonsStreamProvider);
  final splitExpensesAsync = ref.watch(splitExpensesStreamProvider);
  final splitSharesAsync = ref.watch(splitSharesStreamProvider);
  final settlementsAsync = ref.watch(settlementsStreamProvider);

  if (personsAsync.isLoading ||
      splitExpensesAsync.isLoading ||
      splitSharesAsync.isLoading ||
      settlementsAsync.isLoading) {
    return const AsyncValue.loading();
  }

  final persons = personsAsync.value ?? [];
  final splitExpenses = splitExpensesAsync.value ?? [];
  final splitShares = splitSharesAsync.value ?? [];
  final settlements = settlementsAsync.value ?? [];

  final Map<int, String> peopleMap = {for (final p in persons) p.id: p.name};

  final Map<String, SplitExpense> expenseMap = {
    for (final exp in splitExpenses) exp.id: exp,
  };

  final List<RawSplitItem> splitItems = [];
  for (final share in splitShares) {
    final parentExp = expenseMap[share.splitExpenseId];
    if (parentExp != null) {
      splitItems.add(
        RawSplitItem(
          paidByPersonId: parentExp.paidByPersonId,
          sharePersonId: share.personId,
          shareAmountPaise: share.shareAmountPaise,
        ),
      );
    }
  }

  final List<RawSettlementItem> settlementItems = settlements
      .map(
        (s) => RawSettlementItem(
          fromPersonId: s.fromPersonId,
          toPersonId: s.toPersonId,
          amountPaise: s.amountPaise,
        ),
      )
      .toList();

  final result = BalanceCalculator.compute(
    people: peopleMap,
    splitItems: splitItems,
    settlements: settlementItems,
  );

  return AsyncValue.data(result);
});

// Debt Simplification Provider
final debtSimplificationProvider =
    Provider<AsyncValue<List<SimplifiedPayment>>>((ref) {
      final balancesAsync = ref.watch(overallBalancesProvider);
      final personsAsync = ref.watch(activePersonsStreamProvider);

      if (balancesAsync.isLoading || personsAsync.isLoading) {
        return const AsyncValue.loading();
      }

      final balances = balancesAsync.value;
      final persons = personsAsync.value ?? [];
      if (balances == null) return const AsyncValue.data([]);

      final Map<int?, String> participants = {
        null: 'Me',
        for (final p in persons) p.id: p.name,
      };

      final Map<int?, int> netBalances = {
        null: balances.netPositionPaise, // My net position
        for (final pb in balances.personBalances)
          pb.personId: pb.netBalancePaise,
      };

      final payments = DebtSimplifier.simplify(
        participants: participants,
        netBalancesPaise: netBalances,
      );

      return AsyncValue.data(payments);
    });
