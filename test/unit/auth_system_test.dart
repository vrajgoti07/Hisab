import 'package:drift/native.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketplan/data/database/app_database.dart';
import 'package:pocketplan/data/providers/app_providers.dart';
import 'package:pocketplan/data/repositories/pocketplan_repository.dart';
import 'package:pocketplan/features/auth/models/app_user.dart';
import 'package:pocketplan/features/auth/presentation/email_verification_screen.dart';
import 'package:pocketplan/features/auth/presentation/forgot_password_screen.dart';
import 'package:pocketplan/features/auth/presentation/login_screen.dart';
import 'package:pocketplan/features/auth/presentation/signup_screen.dart';
import 'package:pocketplan/features/auth/providers/auth_providers.dart';
import 'package:pocketplan/features/auth/services/auth_exception.dart';
import 'package:pocketplan/features/auth/services/fake_auth_service.dart';

void main() {
  group('AppUser Model Tests', () {
    test('regular unverified email user cannot access app', () {
      const user = AppUser(
        uid: 'u1',
        email: 'test@example.com',
        isEmailVerified: false,
        providerId: 'password',
      );
      expect(user.canAccessApp, isFalse);
      expect(user.isGoogleUser, isFalse);
    });

    test('verified email user can access app', () {
      const user = AppUser(
        uid: 'u2',
        email: 'test@example.com',
        isEmailVerified: true,
        providerId: 'password',
      );
      expect(user.canAccessApp, isTrue);
    });

    test('Google user can access app even before separate verification', () {
      const user = AppUser(
        uid: 'u3',
        email: 'google@gmail.com',
        isEmailVerified: false,
        providerId: 'google.com',
      );
      expect(user.canAccessApp, isTrue);
      expect(user.isGoogleUser, isTrue);
    });
  });

  group('AuthException Mapping Tests', () {
    test('maps standard Firebase exception codes accurately', () {
      final invalidEmail = AuthException.fromFirebase(
        fb.FirebaseAuthException(code: 'invalid-email', message: 'Bad email'),
      );
      expect(invalidEmail.message, contains('invalid'));

      final wrongPass = AuthException.fromFirebase(
        fb.FirebaseAuthException(code: 'wrong-password'),
      );
      expect(wrongPass.message, contains('Incorrect email or password'));

      final alreadyInUse = AuthException.fromFirebase(
        fb.FirebaseAuthException(code: 'email-already-in-use'),
      );
      expect(alreadyInUse.message, contains('already registered'));

      final weakPass = AuthException.fromFirebase(
        fb.FirebaseAuthException(code: 'weak-password'),
      );
      expect(weakPass.message, contains('at least 6 characters'));

      final netErr = AuthException.fromFirebase(
        fb.FirebaseAuthException(code: 'network-request-failed'),
      );
      expect(netErr.message, contains('Network error'));
    });
  });

  group('FakeAuthService Unit Tests', () {
    late FakeAuthService auth;

    setUp(() {
      auth = FakeAuthService();
    });

    tearDown(() {
      auth.dispose();
    });

    test('email login sets user and notifies listeners', () async {
      expect(auth.currentUser, isNull);
      final user = await auth.signInWithEmailAndPassword(
        email: 'aryan@example.com',
        password: 'password123',
      );
      expect(user.email, 'aryan@example.com');
      expect(auth.currentUser, isNotNull);
      expect(user.isEmailVerified, isTrue);
    });

    test('email registration creates unverified user', () async {
      final user = await auth.registerWithEmailAndPassword(
        email: 'new@example.com',
        password: 'password123',
        displayName: 'New User',
      );
      expect(user.email, 'new@example.com');
      expect(user.displayName, 'New User');
      expect(user.isEmailVerified, isFalse);
    });

    test('Google sign in returns verified Google user', () async {
      final user = await auth.signInWithGoogle();
      expect(user, isNotNull);
      expect(user!.isGoogleUser, isTrue);
      expect(user.canAccessApp, isTrue);
    });

    test('Google sign in returns null on cancellation without error', () async {
      auth.isGoogleCanceled = true;
      final user = await auth.signInWithGoogle();
      expect(user, isNull);
    });

    test('signOut clears active user session', () async {
      await auth.signInWithEmailAndPassword(
        email: 'user@example.com',
        password: 'password123',
      );
      expect(auth.currentUser, isNotNull);
      await auth.signOut();
      expect(auth.currentUser, isNull);
    });
  });

  group('Authentication Form Validation Widget Tests', () {
    testWidgets(
      'LoginScreen validates empty and invalid email and short password',
      (tester) async {
        final fakeAuth = FakeAuthService();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [authServiceProvider.overrideWithValue(fakeAuth)],
            child: const MaterialApp(home: LoginScreen()),
          ),
        );

        await tester.pumpAndSettle();

        // Tap Sign In with empty fields
        await tester.tap(find.text('Sign In'));
        await tester.pumpAndSettle();

        expect(find.text('Email is required'), findsOneWidget);
        expect(find.text('Password is required'), findsOneWidget);

        // Enter invalid email and short password
        await tester.enterText(
          find.byType(TextFormField).first,
          'invalid-email',
        );
        await tester.enterText(find.byType(TextFormField).last, '123');
        await tester.tap(find.text('Sign In'));
        await tester.pumpAndSettle();

        expect(find.text('Enter a valid email address'), findsOneWidget);
        expect(
          find.text('Password must be at least 6 characters'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'SignUpScreen validates required fields and password mismatch',
      (tester) async {
        final fakeAuth = FakeAuthService();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [authServiceProvider.overrideWithValue(fakeAuth)],
            child: const MaterialApp(home: SignUpScreen()),
          ),
        );

        await tester.pumpAndSettle();

        // Tap Create Account with empty fields
        final createButtonFinder =
            find.widgetWithText(ElevatedButton, 'Create Account');
        await tester.ensureVisible(createButtonFinder);
        await tester.tap(createButtonFinder);
        await tester.pumpAndSettle();

        expect(find.text('Full name is required'), findsOneWidget);
        expect(find.text('Email is required'), findsOneWidget);
        expect(find.text('Password is required'), findsOneWidget);

        // Enter mismatched password
        await tester.enterText(find.byType(TextFormField).at(0), 'Rahul');
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'rahul@test.com',
        );
        await tester.enterText(find.byType(TextFormField).at(2), 'password123');
        await tester.enterText(find.byType(TextFormField).at(3), 'different');

        await tester.ensureVisible(createButtonFinder);
        await tester.tap(createButtonFinder);
        await tester.pumpAndSettle();

        expect(find.text('Passwords do not match'), findsOneWidget);
      },
    );

    testWidgets('ForgotPasswordScreen validates email and handles submission', (
      tester,
    ) async {
      final fakeAuth = FakeAuthService();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [authServiceProvider.overrideWithValue(fakeAuth)],
          child: const MaterialApp(home: ForgotPasswordScreen()),
        ),
      );

      await tester.pumpAndSettle();

      // Submit empty
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();
      expect(find.text('Email is required'), findsOneWidget);

      // Submit valid email
      await tester.enterText(find.byType(TextFormField), 'aryan@example.com');
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      expect(find.text('Reset Link Sent!'), findsOneWidget);
      expect(find.textContaining('aryan@example.com'), findsOneWidget);
    });

    testWidgets(
      'EmailVerificationScreen displays user email and handles actions',
      (tester) async {
        final fakeAuth = FakeAuthService(
          initialUser: const AppUser(
            uid: 'u_verify',
            email: 'verify.me@example.com',
            isEmailVerified: false,
          ),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [authServiceProvider.overrideWithValue(fakeAuth)],
            child: const MaterialApp(
              home: EmailVerificationScreen(
                registeredEmail: 'verify.me@example.com',
              ),
            ),
          ),
        );

        await tester.pump();
        expect(find.text('Verify Your Email Address'), findsOneWidget);
        expect(find.textContaining('verify.me@example.com'), findsOneWidget);
        expect(find.text('I Have Verified My Email'), findsOneWidget);
        expect(find.text('Resend Verification Link'), findsOneWidget);

        // Tap Resend
        await tester.tap(find.text('Resend Verification Link'));
        await tester.pump();
        expect(find.textContaining('Resend available in'), findsOneWidget);
      },
    );
  });

  group('Local Financial Data Preservation Test', () {
    test(
      'Logout does not erase SQLite database tables or local expenses',
      () async {
        final inMemoryDb = AppDatabase(NativeDatabase.memory());
        final repo = PocketPlanRepository(inMemoryDb);
        await repo.initializeDefaultsIfNeeded();

        final fakeAuth = FakeAuthService(
          initialUser: const AppUser(
            uid: 'uid_test',
            email: 'test@hisab.com',
            isEmailVerified: true,
          ),
        );

        final container = ProviderContainer(
          overrides: [
            databaseProvider.overrideWithValue(inMemoryDb),
            repositoryProvider.overrideWithValue(repo),
            authServiceProvider.overrideWithValue(fakeAuth),
          ],
        );

        // Verify categories exist
        final initialCategories = await repo.getActiveCategories();
        expect(initialCategories.length, greaterThanOrEqualTo(8));

        // Add a test expense
        final now = DateTime.now();
        await repo.insertExpense(
          ExpensesCompanion.insert(
            date: now,
            categoryId: initialCategories.first.id,
            whereSpent: 'Stationery Shop',
            amountPaise: 45000,
            paymentMode: 'Cash',
          ),
        );

        final expensesBefore = await repo.getExpensesForMonth(
          now.year,
          now.month,
        );
        expect(expensesBefore.length, 1);

        // Trigger logout
        await container.read(authNotifierProvider.notifier).logout();

        // Check auth state is logged out
        expect(container.read(authNotifierProvider).isLoggedIn, isFalse);
        expect(fakeAuth.currentUser, isNull);

        // Check SQLite financial records are completely preserved!
        final categoriesAfter = await repo.getActiveCategories();
        final expensesAfter = await repo.getExpensesForMonth(
          now.year,
          now.month,
        );
        expect(categoriesAfter.length, initialCategories.length);
        expect(expensesAfter.length, 1);
        expect(expensesAfter.first.whereSpent, 'Stationery Shop');

        container.dispose();
        await inMemoryDb.close();
      },
    );
  });
}
