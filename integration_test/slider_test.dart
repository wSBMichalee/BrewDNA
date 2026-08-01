import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:hop_iq/main.dart' as app;
import 'package:hop_iq/core/routing/app_router.dart';
import 'package:hop_iq/core/di/injection.dart';
import 'package:hop_iq/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:hop_iq/core/widgets/app_button.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Slider screenshots', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    Future<void> takeScreenshot(String name) async {
      print('SCREENSHOT_READY: $name');
      await Future.delayed(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    }

    final cubit = getIt<OnboardingCubit>();

    print('Navigating to /onboarding/quiz');
    appRouter.go('/onboarding/quiz');
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // We are at Q1. Tap next.
    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Q2
    cubit.updateLightStrong(0);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await takeScreenshot('Q2_0');

    cubit.updateLightStrong(100);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await takeScreenshot('Q2_100');

    // Tap next
    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Q3
    cubit.updateDryFruity(0);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await takeScreenshot('Q3_0');

    cubit.updateDryFruity(100);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await takeScreenshot('Q3_100');

    // Tap next
    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    print('SCREENSHOTS_DONE');
  });
}
