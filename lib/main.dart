import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'data/providers/app_providers.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'widgets/main_shell_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final prefs = await SharedPreferences.getInstance();
  final onboardingDone = prefs.getBool('onboarding_completed') ?? false;

  runApp(
    ProviderScope(
      child: PocketPlanApp(initialOnboardingDone: onboardingDone),
    ),
  );
}

class PocketPlanApp extends ConsumerStatefulWidget {
  final bool initialOnboardingDone;

  const PocketPlanApp({super.key, required this.initialOnboardingDone});

  @override
  ConsumerState<PocketPlanApp> createState() => _PocketPlanAppState();
}

class _PocketPlanAppState extends ConsumerState<PocketPlanApp> {
  late bool _isOnboardingDone;

  @override
  void initState() {
    super.initState();
    _isOnboardingDone = widget.initialOnboardingDone;

    // Initialize defaults in background
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final repo = ref.read(repositoryProvider);
      await repo.initializeDefaultsIfNeeded();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'PocketPlan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: _isOnboardingDone
          ? const MainShellScreen()
          : OnboardingScreen(
              onCompleted: () {
                setState(() => _isOnboardingDone = true);
              },
            ),
    );
  }
}
