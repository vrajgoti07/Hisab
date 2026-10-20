import 'package:drift/drift.dart';
import '../../core/constants/app_constants.dart';
import '../database/app_database.dart';

class PocketPlanRepository {
  final AppDatabase db;

  PocketPlanRepository(this.db);

  // --------------------------------------------------------------------------
  // INITIALIZATION & SEEDING
  // --------------------------------------------------------------------------

  Future<void> initializeDefaultsIfNeeded() async {
    // 1. Check if settings exist
    final settingsList = await db.select(db.appSettings).get();
    if (settingsList.isEmpty) {
      await db
          .into(db.appSettings)
          .insert(
            AppSettingsCompanion.insert(
              userName: const Value('Student'),
              currency: const Value('INR'),
            ),
          );
    }

    // 2. Check if categories exist
    final categoriesList = await db.select(db.categories).get();
    if (categoriesList.isEmpty) {
      int order = 0;
      for (final cat in AppConstants.defaultCategories) {
        await db
            .into(db.categories)
            .insert(
              CategoriesCompanion.insert(
                name: cat.name,
                emoji: cat.emoji,
                colorHex: cat.colorHex,
                monthlyLimitPaise: cat.defaultLimitPaise,
                sortOrder: Value(order++),
              ),
            );
      }
    }

    // 3. Check if payment modes exist
    final modesList = await db.select(db.paymentModes).get();
    if (modesList.isEmpty) {
      for (final mode in AppConstants.defaultPaymentModes) {
        await db
            .into(db.paymentModes)
            .insert(PaymentModesCompanion.insert(name: mode));
      }
    }
  }

  /// Seeds one full month of demo data (October 2026 / current month)
  Future<void> seedDemoData({int? year, int? month}) async {
    final now = DateTime.now();
    final y = year ?? now.year;
    final m = month ?? now.month;

    // 1. Ensure Defaults
    await initializeDefaultsIfNeeded();

    // 2. Seed Monthly Budget of ₹25,000 (2500000 paise)
    await db
        .into(db.monthlyBudgets)
        .insertOnConflictUpdate(
          MonthlyBudgetsCompanion.insert(
            year: y,
            month: m,
            amountPaise: 2500000,
            carryForward: const Value(true),
            carriedAmountPaise: const Value(0),
          ),
        );

    // 3. Seed Friends (Rahul, Priya, Amit, Sneha)
    final existingPersons = await db.select(db.persons).get();
    int rahulId = 1, priyaId = 2, amitId = 3;
    if (existingPersons.isEmpty) {
      rahulId = await db
          .into(db.persons)
          .insert(
            PersonsCompanion.insert(
              name: 'Rahul Sharma',
              phone: const Value('9876543210'),
              avatarColor: const Value('#3B82F6'),
            ),
          );
      priyaId = await db
          .into(db.persons)
          .insert(
            PersonsCompanion.insert(
              name: 'Priya Patel',
              phone: const Value('9812345678'),
              avatarColor: const Value('#EC4899'),
            ),
          );
      amitId = await db
          .into(db.persons)
          .insert(
            PersonsCompanion.insert(
              name: 'Amit Verma',
              phone: const Value('9723456789'),
              avatarColor: const Value('#10B981'),
            ),
          );
      await db
          .into(db.persons)
          .insert(
            PersonsCompanion.insert(
              name: 'Sneha Joshi',
              phone: const Value('9988776655'),
              avatarColor: const Value('#8B5CF6'),
            ),
          );
    } else {
      rahulId = existingPersons[0].id;
      if (existingPersons.length > 1) priyaId = existingPersons[1].id;
      if (existingPersons.length > 2) amitId = existingPersons[2].id;
    }

    // Get Categories
    final categories = await db.select(db.categories).get();
    final foodCat = categories.firstWhere(
      (c) => c.name.contains('Food'),
      orElse: () => categories.first,
    );
    final travelCat = categories.firstWhere(
      (c) => c.name.contains('Travel'),
      orElse: () => categories.first,
    );
    final studyCat = categories.firstWhere(
      (c) => c.name.contains('Study'),
      orElse: () => categories.first,
    );
    final entCat = categories.firstWhere(
      (c) => c.name.contains('Entertainment'),
      orElse: () => categories.first,
    );
    final billsCat = categories.firstWhere(
      (c) => c.name.contains('Mobile'),
      orElse: () => categories.first,
    );
    final savingsCat = categories.firstWhere(
      (c) => c.name.contains('Savings'),
      orElse: () => categories.first,
    );

    // 4. Seed Expenses (10 diverse expenses)
    final demoDate = DateTime(y, m, 5);
    final sampleExpenses = [
      (
        demoDate.subtract(const Duration(days: 4)),
        foodCat.id,
        'College Canteen Lunch',
        12000,
        'UPI / GPay / PhonePe',
        'Snacks with classmates',
      ),
      (
        demoDate.subtract(const Duration(days: 3)),
        travelCat.id,
        'Metro SmartCard Recharge',
        50000,
        'UPI / GPay / PhonePe',
        'Monthly pass',
      ),
      (
        demoDate.subtract(const Duration(days: 2)),
        studyCat.id,
        'Engineering Physics Textbook',
        65000,
        'Cash',
        'Second hand book store',
      ),
      (
        demoDate.subtract(const Duration(days: 1)),
        foodCat.id,
        'Grocery & Maggi',
        45000,
        'UPI / GPay / PhonePe',
        'Hostel stock',
      ),
      (
        demoDate,
        billsCat.id,
        'Jio 84 Days Recharge',
        47900,
        'UPI / GPay / PhonePe',
        'Mobile plan',
      ),
      (
        demoDate.add(const Duration(days: 1)),
        entCat.id,
        'Movie Ticket (Interstellar Rerun)',
        35000,
        'Debit Card',
        'Weekend show',
      ),
      (
        demoDate.add(const Duration(days: 2)),
        foodCat.id,
        'Dinner with Roommates (My share)',
        38000,
        'UPI / GPay / PhonePe',
        'Cafe visit',
      ),
      (
        demoDate.add(const Duration(days: 3)),
        travelCat.id,
        'Auto Rickshaw to Station',
        18000,
        'Cash',
        'Railway commute',
      ),
      (
        demoDate.add(const Duration(days: 4)),
        savingsCat.id,
        'Transferred to RD Savings',
        250000,
        'Net Banking',
        'Monthly goal',
      ),
    ];

    for (final exp in sampleExpenses) {
      await db
          .into(db.expenses)
          .insert(
            ExpensesCompanion.insert(
              date: exp.$1,
              categoryId: exp.$2,
              whereSpent: exp.$3,
              amountPaise: exp.$4,
              paymentMode: exp.$5,
              note: Value(exp.$6),
            ),
          );
    }

    // 5. Seed 2 Split Expenses
    // Split 1: Dominos Pizza ₹1,200 equal among Me, Rahul, Priya, Amit (₹300 each)
    const split1Id = 'SPL-DEMO-001';
    await db
        .into(db.splitExpenses)
        .insertOnConflictUpdate(
          SplitExpensesCompanion.insert(
            id: split1Id,
            date: DateTime(y, m, 4),
            title: 'Dominos Pizza Party',
            groupName: const Value('Hostel Weekend'),
            totalAmountPaise: 120000,
            paidByPersonId: const Value(null), // Me paid
            splitType: 'Equal',
            categoryId: Value(foodCat.id),
            note: const Value('Ordered via Zomato'),
          ),
        );

    await db
        .into(db.splitShares)
        .insert(
          SplitSharesCompanion.insert(
            splitExpenseId: split1Id,
            personId: const Value(null),
            shareAmountPaise: 30000,
          ),
        );
    await db
        .into(db.splitShares)
        .insert(
          SplitSharesCompanion.insert(
            splitExpenseId: split1Id,
            personId: Value(rahulId),
            shareAmountPaise: 30000,
          ),
        );
    await db
        .into(db.splitShares)
        .insert(
          SplitSharesCompanion.insert(
            splitExpenseId: split1Id,
            personId: Value(priyaId),
            shareAmountPaise: 30000,
          ),
        );
    await db
        .into(db.splitShares)
        .insert(
          SplitSharesCompanion.insert(
            splitExpenseId: split1Id,
            personId: Value(amitId),
            shareAmountPaise: 30000,
          ),
        );

    // Split 2: Rahul paid for Resort booking ₹6,000. My share is ₹2,000 (I owe Rahul ₹2,000)
    const split2Id = 'SPL-DEMO-002';
    await db
        .into(db.splitExpenses)
        .insertOnConflictUpdate(
          SplitExpensesCompanion.insert(
            id: split2Id,
            date: DateTime(y, m, 8),
            title: 'Goa Trip Resort Advance',
            groupName: const Value('Goa 2026'),
            totalAmountPaise: 600000,
            paidByPersonId: Value(rahulId), // Rahul paid
            splitType: 'Equal',
            categoryId: Value(travelCat.id),
            note: const Value('Paid by Rahul for 3 people'),
          ),
        );

    await db
        .into(db.splitShares)
        .insert(
          SplitSharesCompanion.insert(
            splitExpenseId: split2Id,
            personId: const Value(null),
            shareAmountPaise: 200000,
          ),
        );
    await db
        .into(db.splitShares)
        .insert(
          SplitSharesCompanion.insert(
            splitExpenseId: split2Id,
            personId: Value(rahulId),
            shareAmountPaise: 200000,
          ),
        );
    await db
        .into(db.splitShares)
        .insert(
          SplitSharesCompanion.insert(
            splitExpenseId: split2Id,
            personId: Value(amitId),
            shareAmountPaise: 200000,
          ),
        );

    // 6. Seed 1 Partial Settlement: Rahul repaid ₹300 for pizza
    await db
        .into(db.settlements)
        .insert(
          SettlementsCompanion.insert(
            date: DateTime(y, m, 7),
            fromPersonId: Value(rahulId),
            toPersonId: const Value(null), // to Me
            amountPaise: 30000,
            mode: const Value('UPI / GPay / PhonePe'),
            note: const Value('Cleared pizza share via GPay'),
          ),
        );

    // 7. Seed Savings Goals
    final existingGoals = await db.select(db.savingsGoals).get();
    if (existingGoals.isEmpty) {
      await db
          .into(db.savingsGoals)
          .insert(
            SavingsGoalsCompanion.insert(
              name: 'Laptop Upgrade',
              targetPaise: 6000000, // ₹60,000
              savedPaise: const Value(2200000), // ₹22,000
              emoji: const Value('💻'),
              deadline: Value(DateTime(y, 12, 31)),
            ),
          );
      await db
          .into(db.savingsGoals)
          .insert(
            SavingsGoalsCompanion.insert(
              name: 'Emergency Fund',
              targetPaise: 2500000, // ₹25,000
              savedPaise: const Value(1500000), // ₹15,000
              emoji: const Value('🛡️'),
            ),
          );
    }
  }

  /// Clears demo/user data and resets to initial fresh state
  Future<void> clearAllData() async {
    await db.delete(db.expenses).go();
    await db.delete(db.splitShares).go();
    await db.delete(db.splitExpenses).go();
    await db.delete(db.settlements).go();
    await db.delete(db.monthlyBudgets).go();
    await db.delete(db.savingsGoals).go();
    await db.delete(db.recurringExpenses).go();
  }

  // --------------------------------------------------------------------------
  // MONTHLY BUDGETS
  // --------------------------------------------------------------------------

  Future<MonthlyBudget?> getMonthlyBudget(int year, int month) async {
    final query = db.select(db.monthlyBudgets)
      ..where((b) => b.year.equals(year) & b.month.equals(month));
    return query.getSingleOrNull();
  }

  Stream<MonthlyBudget?> watchMonthlyBudget(int year, int month) {
    final query = db.select(db.monthlyBudgets)
      ..where((b) => b.year.equals(year) & b.month.equals(month));
    return query.watchSingleOrNull();
  }

  Future<void> setMonthlyBudget({
    required int year,
    required int month,
    required int amountPaise,
    bool carryForward = true,
    int carriedAmountPaise = 0,
  }) async {
    await db
        .into(db.monthlyBudgets)
        .insertOnConflictUpdate(
          MonthlyBudgetsCompanion.insert(
            year: year,
            month: month,
            amountPaise: amountPaise,
            carryForward: Value(carryForward),
            carriedAmountPaise: Value(carriedAmountPaise),
          ),
        );
  }

  Future<List<MonthlyBudget>> getYearlyBudgets(int year) async {
    final query = db.select(db.monthlyBudgets)
      ..where((b) => b.year.equals(year))
      ..orderBy([(b) => OrderingTerm.asc(b.month)]);
    return query.get();
  }

  // --------------------------------------------------------------------------
  // EXPENSES
  // --------------------------------------------------------------------------

  Stream<List<Expense>> watchExpensesForMonth(int year, int month) {
    final start = DateTime(year, month, 1);
    final end = month == 12
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, month + 1, 1);
    final query = db.select(db.expenses)
      ..where(
        (e) =>
            e.date.isBiggerOrEqualValue(start) & e.date.isSmallerThanValue(end),
      )
      ..orderBy([
        (e) => OrderingTerm.desc(e.date),
        (e) => OrderingTerm.desc(e.id),
      ]);
    return query.watch();
  }

  Future<List<Expense>> getExpensesForMonth(int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = month == 12
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, month + 1, 1);
    final query = db.select(db.expenses)
      ..where(
        (e) =>
            e.date.isBiggerOrEqualValue(start) & e.date.isSmallerThanValue(end),
      )
      ..orderBy([
        (e) => OrderingTerm.desc(e.date),
        (e) => OrderingTerm.desc(e.id),
      ]);
    return query.get();
  }

  Future<int> insertExpense(ExpensesCompanion expense) async {
    return db.into(db.expenses).insert(expense);
  }

  Future<bool> updateExpense(Expense expense) async {
    return db.update(db.expenses).replace(expense);
  }

  Future<int> deleteExpense(int id) async {
    return (db.delete(db.expenses)..where((e) => e.id.equals(id))).go();
  }

  Future<List<String>> getDistinctWhereSpent() async {
    final expenses = await db.select(db.expenses).get();
    final set = <String>{};
    for (final e in expenses) {
      if (e.whereSpent.trim().isNotEmpty) {
        set.add(e.whereSpent.trim());
      }
    }
    return set.toList();
  }

  // --------------------------------------------------------------------------
  // CATEGORIES
  // --------------------------------------------------------------------------

  Stream<List<Category>> watchActiveCategories() {
    final query = db.select(db.categories)
      ..where((c) => c.isActive.equals(true))
      ..orderBy([
        (c) => OrderingTerm.asc(c.sortOrder),
        (c) => OrderingTerm.asc(c.id),
      ]);
    return query.watch();
  }

  Future<List<Category>> getActiveCategories() async {
    final query = db.select(db.categories)
      ..where((c) => c.isActive.equals(true))
      ..orderBy([
        (c) => OrderingTerm.asc(c.sortOrder),
        (c) => OrderingTerm.asc(c.id),
      ]);
    return query.get();
  }

  Future<int> insertCategory(CategoriesCompanion category) async {
    return db.into(db.categories).insert(category);
  }

  Future<bool> updateCategory(Category category) async {
    return db.update(db.categories).replace(category);
  }

  // --------------------------------------------------------------------------
  // PERSONS / FRIENDS
  // --------------------------------------------------------------------------

  Stream<List<Person>> watchActivePersons() {
    final query = db.select(db.persons)
      ..where((p) => p.isArchived.equals(false))
      ..orderBy([(p) => OrderingTerm.asc(p.name)]);
    return query.watch();
  }

  Future<List<Person>> getActivePersons() async {
    final query = db.select(db.persons)
      ..where((p) => p.isArchived.equals(false))
      ..orderBy([(p) => OrderingTerm.asc(p.name)]);
    return query.get();
  }

  Future<int> insertPerson(PersonsCompanion person) async {
    return db.into(db.persons).insert(person);
  }

  Future<bool> updatePerson(Person person) async {
    return db.update(db.persons).replace(person);
  }

  Future<void> archivePerson(int id) async {
    await (db.update(db.persons)..where((p) => p.id.equals(id))).write(
      const PersonsCompanion(isArchived: Value(true)),
    );
  }

  // --------------------------------------------------------------------------
  // SPLIT EXPENSES & SETTLEMENTS
  // --------------------------------------------------------------------------

  Stream<List<SplitExpense>> watchSplitExpenses() {
    final query = db.select(db.splitExpenses)
      ..orderBy([(s) => OrderingTerm.desc(s.date)]);
    return query.watch();
  }

  Future<List<SplitExpense>> getAllSplitExpenses() async {
    return db.select(db.splitExpenses).get();
  }

  Stream<List<SplitShare>> watchAllSplitShares() {
    return db.select(db.splitShares).watch();
  }

  Future<List<SplitShare>> getAllSplitShares() async {
    return db.select(db.splitShares).get();
  }

  Future<void> insertSplitExpense({
    required SplitExpensesCompanion expense,
    required List<SplitSharesCompanion> shares,
    bool syncMyShareToPersonalExpenses = false,
    int? personalExpenseCategoryId,
  }) async {
    await db.transaction(() async {
      await db.into(db.splitExpenses).insert(expense);
      for (final share in shares) {
        await db.into(db.splitShares).insert(share);
      }

      // If user wants personal share synced to personal expenses
      if (syncMyShareToPersonalExpenses) {
        final myShare = shares.firstWhere(
          (s) => s.personId.value == null,
          orElse: () => const SplitSharesCompanion(),
        );

        if (myShare.shareAmountPaise.present &&
            myShare.shareAmountPaise.value > 0) {
          await db
              .into(db.expenses)
              .insert(
                ExpensesCompanion.insert(
                  date: expense.date.value,
                  categoryId:
                      personalExpenseCategoryId ??
                      expense.categoryId.value ??
                      1,
                  whereSpent: '${expense.title.value} (My Share)',
                  amountPaise: myShare.shareAmountPaise.value,
                  paymentMode: 'UPI / GPay / PhonePe',
                  note: Value('Synced from Split: ${expense.id.value}'),
                  splitExpenseId: Value(expense.id.value),
                ),
              );
        }
      }
    });
  }

  Stream<List<Settlement>> watchSettlements() {
    final query = db.select(db.settlements)
      ..orderBy([(s) => OrderingTerm.desc(s.date)]);
    return query.watch();
  }

  Future<List<Settlement>> getAllSettlements() async {
    return db.select(db.settlements).get();
  }

  Future<int> insertSettlement(SettlementsCompanion settlement) async {
    return db.into(db.settlements).insert(settlement);
  }

  // --------------------------------------------------------------------------
  // SAVINGS GOALS
  // --------------------------------------------------------------------------

  Stream<List<SavingsGoal>> watchSavingsGoals() {
    return db.select(db.savingsGoals).watch();
  }

  Future<int> insertSavingsGoal(SavingsGoalsCompanion goal) async {
    return db.into(db.savingsGoals).insert(goal);
  }

  Future<bool> updateSavingsGoal(SavingsGoal goal) async {
    return db.update(db.savingsGoals).replace(goal);
  }

  // --------------------------------------------------------------------------
  // APP SETTINGS
  // --------------------------------------------------------------------------

  Stream<AppSetting?> watchAppSettings() {
    return db.select(db.appSettings).watchSingleOrNull();
  }

  Future<AppSetting?> getAppSettings() async {
    return (db.select(db.appSettings)..limit(1)).getSingleOrNull();
  }

  Future<void> updateAppSettings(AppSettingsCompanion settings) async {
    await (db.update(
      db.appSettings,
    )..where((s) => s.id.equals(1))).write(settings);
  }
}
