import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hop_iq/main.dart' as app;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Check session test', (WidgetTester tester) async {
    await dotenv.load(fileName: ".env");
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    final user = Supabase.instance.client.auth.currentUser;
    print('SESSION_CHECK_RESULT: ${user?.id}');
    if (user != null) {
      print('SESSION_CHECK_EMAIL: ${user.email}');
    } else {
      print('SESSION_CHECK_RESULT_USER_IS_NULL');
    }
  });
}
