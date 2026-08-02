import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hop_iq/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Navigate to styles and screenshot', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Wait for splash screen to finish
    await Future.delayed(const Duration(seconds: 30));
    await tester.pumpAndSettle();

    // Start
    final startButton = find.text('Zaczynamy');
    if (startButton.evaluate().isNotEmpty) {
      await tester.tap(startButton);
      await tester.pumpAndSettle();
    }

    // Q1: Experience -> next
    final nextBtn = find.text('Dalej');
    if (nextBtn.evaluate().isNotEmpty) {
      await tester.tap(nextBtn);
      await tester.pumpAndSettle();
    }

    // Q2: Light/Strong -> next
    if (nextBtn.evaluate().isNotEmpty) {
      await tester.tap(nextBtn);
      await tester.pumpAndSettle();
    }

    // Q3: Dry/Fruity -> next
    if (nextBtn.evaluate().isNotEmpty) {
      await tester.tap(nextBtn);
      await tester.pumpAndSettle();
    }

    // Interstitial -> next
    if (nextBtn.evaluate().isNotEmpty) {
      await tester.tap(nextBtn);
      await tester.pumpAndSettle();
    }

    // Now we should be on Styles page
    await Future.delayed(const Duration(seconds: 30)); // Wait for styles to load
    await tester.pumpAndSettle();
  });
}
