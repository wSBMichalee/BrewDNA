import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:hop_iq/main.dart' as app;
import 'package:hop_iq/core/routing/app_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hop_iq/features/beer/domain/entities/review.dart';
import 'package:hop_iq/features/beer/domain/entities/rating_histogram.dart';
import 'package:hop_iq/core/di/injection.dart';
import 'dart:io';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Screenshot automation', (WidgetTester tester) async {
    // 2. Start app
    app.main();
    await tester.pumpAndSettle();

    // Helper for taking screenshots
    Future<void> takeScreenshot(String name) async {
      print('SCREENSHOT_READY: $name');
      // Wait a bit for bash script to actually take the screenshot
      await Future.delayed(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    }

    // List of screens to automate
    // We get a valid beer UUID for details screen
    final beerId = 'a0000000-0000-0000-0000-000000000001';

    final routes = [
      {'path': '/', 'name': '01_splash_screen'},
      {'path': '/onboarding/intro', 'name': '02_onboarding_intro'},
      {'path': '/onboarding/quiz', 'name': '03_onboarding_quiz'},
      {'path': '/onboarding/hook', 'name': '04_onboarding_hook'},
      {'path': '/auth/start', 'name': '05_auth_start'},
      {'path': '/auth/email', 'name': '06_auth_email'},
      {'path': '/auth/password', 'name': '07_auth_password'},
      {'path': '/auth/details', 'name': '08_auth_details'},
      {'path': '/auth/welcome', 'name': '09_auth_welcome'},
      {'path': '/main/discover', 'name': '10_main_discover'},
      {'path': '/main/map', 'name': '11_main_map'},
      {'path': '/main/history', 'name': '12_main_history'},
      {'path': '/main/profile', 'name': '13_main_profile'},
      {'path': '/main/beer/$beerId', 'name': '14_beer_details'},
      {'path': '/paywall', 'name': '16_paywall'},
    ];

    for (var route in routes) {
      final path = route['path']!;
      final name = route['name']!;
      
      print('Navigating to $path');
      appRouter.go(path);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await takeScreenshot(name);
    }

    // 15_beer_reviews requires extra
    print('Navigating to /main/reviews');
    appRouter.go('/main/reviews', extra: {
      'beerId': beerId,
      'beerName': 'IPA',
      'histogram': RatingHistogram(count5: 0, count4: 0, count3: 0, count2: 0, count1: 0, averageRating: 0.0, totalCount: 0),
      'reviews': <Review>[],
    });
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await takeScreenshot('15_beer_reviews');

    print('SCREENSHOTS_DONE');
  });
}
