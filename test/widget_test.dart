import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketplan/main.dart';
import 'package:pocketplan/widgets/app_animated_ring.dart';

void main() {
  testWidgets('PocketPlanApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PocketPlanApp(initialOnboardingDone: true),
      ),
    );
    // Initial frame
    await tester.pump();
    expect(find.byType(PocketPlanApp), findsOneWidget);
    // Finish any remaining animation frames
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('AnimatedProgressRing widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AnimatedProgressRing(percentage: 0.5),
      ),
    );
    await tester.pump(const Duration(milliseconds: 900));
    expect(find.byType(AnimatedProgressRing), findsOneWidget);
  });
}
