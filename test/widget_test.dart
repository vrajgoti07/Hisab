import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketplan/data/database/app_database.dart';
import 'package:pocketplan/data/providers/app_providers.dart';
import 'package:pocketplan/data/repositories/pocketplan_repository.dart';
import 'package:pocketplan/features/expenses/presentation/add_edit_expense_sheet.dart';
import 'package:pocketplan/features/onboarding/presentation/onboarding_screen.dart';
import 'package:pocketplan/main.dart';
import 'package:pocketplan/widgets/app_animated_ring.dart';
import 'package:pocketplan/widgets/main_shell_screen.dart';

void main() {
  testWidgets(
    'App opens OnboardingScreen when initialOnboardingDone is false',
    (WidgetTester tester) async {
      final inMemoryDb = AppDatabase(NativeDatabase.memory());
      final testRepo = PocketPlanRepository(inMemoryDb);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(inMemoryDb),
            repositoryProvider.overrideWithValue(testRepo),
          ],
          child: const HisabApp(initialOnboardingDone: false),
        ),
      );

      await tester.pump();
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.byType(MainShellScreen), findsNothing);

      // Unmount and flush before closing db
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
      await inMemoryDb.close();
    },
  );

  testWidgets('App opens MainShellScreen when initialOnboardingDone is true', (
    WidgetTester tester,
  ) async {
    final inMemoryDb = AppDatabase(NativeDatabase.memory());
    final testRepo = PocketPlanRepository(inMemoryDb);
    await testRepo.initializeDefaultsIfNeeded();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(inMemoryDb),
          repositoryProvider.overrideWithValue(testRepo),
        ],
        child: const HisabApp(initialOnboardingDone: true),
      ),
    );

    await tester.pump();
    expect(find.byType(MainShellScreen), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);
    await tester.pump(const Duration(seconds: 1));

    // Unmount and flush before closing db
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
    await inMemoryDb.close();
  });

  testWidgets('MainShell bottom navigation switches screens', (
    WidgetTester tester,
  ) async {
    final inMemoryDb = AppDatabase(NativeDatabase.memory());
    final testRepo = PocketPlanRepository(inMemoryDb);
    await testRepo.initializeDefaultsIfNeeded();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(inMemoryDb),
          repositoryProvider.overrideWithValue(testRepo),
        ],
        child: const HisabApp(initialOnboardingDone: true),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Initially on Dashboard
    expect(find.text('Hisab'), findsWidgets);

    // Tap on Expenses tab
    await tester.tap(find.text('Expenses'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Expenses ('), findsOneWidget);

    // Tap on Friends tab
    await tester.tap(find.text('Friends'));
    await tester.pumpAndSettle();
    expect(find.text('Friends & Split Hisab'), findsOneWidget);

    // Tap on Reports tab
    await tester.tap(find.text('Reports'));
    await tester.pumpAndSettle();
    expect(find.text('Reports & Audit'), findsOneWidget);

    // Tap on Settings tab
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings & Preferences'), findsOneWidget);

    // Unmount and flush before closing db
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
    await inMemoryDb.close();
  });

  testWidgets('AppStartupErrorScreen displays error and triggers retry', (
    WidgetTester tester,
  ) async {
    bool retryClicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: AppStartupErrorScreen(
          errorMessage: 'Corrupt storage error',
          onRetry: () {
            retryClicked = true;
          },
        ),
      ),
    );

    expect(find.text('Initialization Issue'), findsOneWidget);
    expect(find.textContaining('Corrupt storage error'), findsOneWidget);

    await tester.tap(find.text('Retry Startup'));
    await tester.pump();
    expect(retryClicked, isTrue);
  });

  testWidgets('AnimatedProgressRing renders smoothly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AnimatedProgressRing(percentage: 0.65)),
      ),
    );

    await tester.pump(const Duration(milliseconds: 900));
    expect(find.byType(AnimatedProgressRing), findsOneWidget);
  });

  testWidgets('AddEditExpenseSheet validates empty input', (
    WidgetTester tester,
  ) async {
    final inMemoryDb = AppDatabase(NativeDatabase.memory());
    final testRepo = PocketPlanRepository(inMemoryDb);
    await testRepo.initializeDefaultsIfNeeded();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(inMemoryDb),
          repositoryProvider.overrideWithValue(testRepo),
        ],
        child: const MaterialApp(home: Scaffold(body: AddEditExpenseSheet())),
      ),
    );

    await tester.pumpAndSettle();

    // Ensure button is scrolled into view in 800x600 test viewport
    final saveButtonFinder = find.text('Save Expense');
    await tester.ensureVisible(saveButtonFinder);
    await tester.pumpAndSettle();

    // Tap Save Expense with empty amount
    await tester.tap(saveButtonFinder);
    await tester.pumpAndSettle();

    expect(
      find.text('Please enter a valid amount greater than ₹0.'),
      findsOneWidget,
    );

    // Unmount and flush before closing db
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
    await inMemoryDb.close();
  });
}
