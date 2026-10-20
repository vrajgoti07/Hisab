import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_icons.dart';
import 'core/theme/app_theme.dart';
import 'data/providers/app_providers.dart';
import 'features/auth/presentation/email_verification_screen.dart';
import 'features/auth/presentation/firebase_config_notice_screen.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/providers/auth_providers.dart';
import 'features/auth/services/fake_auth_service.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'widgets/main_shell_screen.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Set standard system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
        ),
      );

      SharedPreferences? prefs;
      Object? initError;

      try {
        prefs = await SharedPreferences.getInstance();
      } catch (e, stack) {
        initError = e;
        debugPrint('SharedPreferences init error: $e\n$stack');
      }

      if (initError != null || prefs == null) {
        runApp(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: AppStartupErrorScreen(
              errorMessage:
                  initError?.toString() ?? 'Failed to initialize local storage',
              onRetry: () => main(),
            ),
          ),
        );
        return;
      }

      bool firebaseInitialized = false;
      Object? firebaseInitError;

      try {
        await Firebase.initializeApp();
        firebaseInitialized = true;
      } catch (e, stack) {
        firebaseInitError = e;
        debugPrint('Firebase initialization notice: $e\n$stack');
      }

      final onboardingDone = prefs.getBool('onboarding_completed') ?? false;

      runApp(
        _HisabBootstrap(
          prefs: prefs,
          firebaseInitialized: firebaseInitialized,
          firebaseInitError: firebaseInitError,
          initialOnboardingDone: onboardingDone,
        ),
      );
    },
    (error, stack) {
      debugPrint('Uncaught Hisab app error: $error\n$stack');
    },
  );
}

/// Handles bootstrap lifecycle, providing Firebase fallback if credentials are not yet configured.
class _HisabBootstrap extends StatefulWidget {
  final SharedPreferences prefs;
  final bool firebaseInitialized;
  final Object? firebaseInitError;
  final bool initialOnboardingDone;

  const _HisabBootstrap({
    required this.prefs,
    required this.firebaseInitialized,
    required this.firebaseInitError,
    required this.initialOnboardingDone,
  });

  @override
  State<_HisabBootstrap> createState() => _HisabBootstrapState();
}

class _HisabBootstrapState extends State<_HisabBootstrap> {
  late bool _firebaseReady;
  bool _useDemoAuth = false;

  @override
  void initState() {
    super.initState();
    _firebaseReady = widget.firebaseInitialized;
  }

  Future<void> _retryFirebaseInit() async {
    try {
      await Firebase.initializeApp();
      if (mounted) {
        setState(() {
          _firebaseReady = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Firebase init failed: $e'),
            backgroundColor: AppColors.dangerRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_firebaseReady && !_useDemoAuth) {
      return MaterialApp(
        title: 'Hisab',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: FirebaseConfigNoticeScreen(
          error: widget.firebaseInitError,
          onRetry: _retryFirebaseInit,
          onContinueWithDemo: () {
            setState(() => _useDemoAuth = true);
          },
        ),
      );
    }

    final overrides = <Override>[
      sharedPreferencesProvider.overrideWithValue(widget.prefs),
    ];

    if (_useDemoAuth) {
      overrides.add(authServiceProvider.overrideWithValue(FakeAuthService()));
    }

    return ProviderScope(
      overrides: overrides,
      child: HisabApp(initialOnboardingDone: widget.initialOnboardingDone),
    );
  }
}

class HisabApp extends ConsumerStatefulWidget {
  final bool initialOnboardingDone;
  final bool? initialLoggedIn;

  const HisabApp({
    super.key,
    required this.initialOnboardingDone,
    this.initialLoggedIn,
  });

  @override
  ConsumerState<HisabApp> createState() => _HisabAppState();
}

class _HisabAppState extends ConsumerState<HisabApp> {
  late bool _isOnboardingDone;
  bool _isInitFailed = false;
  String? _initErrorMessage;

  @override
  void initState() {
    super.initState();
    _isOnboardingDone = widget.initialOnboardingDone;

    // Initialize database defaults non-blockingly in the background
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final repo = ref.read(repositoryProvider);
        await repo.initializeDefaultsIfNeeded();
      } catch (e) {
        debugPrint('Non-fatal database default init error: $e');
        if (mounted && !_isOnboardingDone) {
          setState(() {
            _isInitFailed = true;
            _initErrorMessage = e.toString();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    if (_isInitFailed) {
      return MaterialApp(
        title: 'Hisab',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: AppStartupErrorScreen(
          errorMessage:
              _initErrorMessage ?? 'Failed to initialize database defaults',
          onRetry: () async {
            setState(() {
              _isInitFailed = false;
              _initErrorMessage = null;
            });
            try {
              final repo = ref.read(repositoryProvider);
              await repo.initializeDefaultsIfNeeded();
            } catch (e) {
              if (mounted) {
                setState(() {
                  _isInitFailed = true;
                  _initErrorMessage = e.toString();
                });
              }
            }
          },
        ),
      );
    }

    final authState = ref.watch(authNotifierProvider);
    final currentUser = ref.watch(currentUserProvider);

    // Routing resolution:
    // 1. If explicit test override provided (widget.initialLoggedIn == false), show LoginScreen
    // 2. If user is unauthenticated, show LoginScreen
    // 3. If user is registered with email/pass but unverified, show EmailVerificationScreen
    // 4. If user is authenticated and verified:
    //    - If onboarding not completed, show OnboardingScreen
    //    - If onboarding completed, show MainShellScreen
    Widget homeScreen;

    if (widget.initialLoggedIn == false) {
      homeScreen = const LoginScreen();
    } else if (widget.initialLoggedIn == true) {
      if (!_isOnboardingDone) {
        homeScreen = OnboardingScreen(
          onCompleted: () => setState(() => _isOnboardingDone = true),
        );
      } else {
        homeScreen = const MainShellScreen();
      }
    } else if (!authState.isLoggedIn) {
      if (currentUser != null && !currentUser.canAccessApp) {
        homeScreen = EmailVerificationScreen(
          registeredEmail: currentUser.email,
        );
      } else {
        homeScreen = const LoginScreen();
      }
    } else if (!_isOnboardingDone) {
      homeScreen = OnboardingScreen(
        onCompleted: () => setState(() => _isOnboardingDone = true),
      );
    } else {
      homeScreen = const MainShellScreen();
    }

    return MaterialApp(
      title: 'Hisab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: homeScreen,
    );
  }
}

// Backward-compatible alias for existing test references
typedef PocketPlanApp = HisabApp;

/// User-friendly startup error screen with actionable retry
class AppStartupErrorScreen extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const AppStartupErrorScreen({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.dangerRed.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      AppIcons.error,
                      size: 40,
                      color: AppColors.dangerRed,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Initialization Issue',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Hisab encountered a problem during startup:\n$errorMessage',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(AppIcons.refresh, size: 18),
                  label: const Text('Retry Startup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
