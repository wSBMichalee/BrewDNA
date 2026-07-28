import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hop_iq/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Normal flow test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Splash to Intro?
    // Intro to Quiz:
    final startBtn = find.text('Zaczynamy'); // or Rozpocznij? Let me check intro screen
    if (startBtn.evaluate().isNotEmpty) {
      await tester.tap(startBtn);
      await tester.pumpAndSettle();
    }
  });
}
