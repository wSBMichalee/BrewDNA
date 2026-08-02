import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

void main() async {
  // Load .env file manually since we are running as a dart script
  final envContent = await File('.env').readAsString();
  final envVars = <String, String>{};
  for (final line in envContent.split('\n')) {
    if (line.trim().isNotEmpty && !line.startsWith('#')) {
      final parts = line.split('=');
      if (parts.length >= 2) {
        envVars[parts[0].trim()] = parts.sublist(1).join('=').trim();
      }
    }
  }

  final supabaseUrl = envVars['SUPABASE_URL']!;
  final supabaseAnonKey = envVars['SUPABASE_ANON_KEY']!;

  final client = SupabaseClient(supabaseUrl, supabaseAnonKey);
  
  final email = 'tester_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final password = 'Password123!';
  final name = 'Test User Agent';

  print('Registering user: $email');

  try {
    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: {'display_name': name},
    );

    if (response.user != null) {
      print('User registered successfully! ID: ${response.user!.id}');
      print('Waiting 2 seconds for DB trigger to create public.users row...');
      await Future.delayed(Duration(seconds: 2));

      print('Updating display_name manually just like details_screen.dart does...');
      await client
          .from('users')
          .update({'display_name': name})
          .eq('id', response.user!.id);

      print('Fetching user from public.users table...');
      final userData = await client
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();
      print('User data in public.users: $userData');
    } else {
      print('Registration failed.');
    }
  } catch (e) {
    print('Error: $e');
  }
}
