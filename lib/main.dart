import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/di/injection.dart';
import 'core/routing/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize DI
  configureDependencies();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase (requires url and publishableKey in .env)
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    publishableKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  // Test query
  try {
    final res = await Supabase.instance.client.from('styles').select().limit(1);
    debugPrint('TEST QUERY RESULT: $res');
  } catch (e) {
    debugPrint('TEST QUERY ERROR: $e');
  }

  runApp(const BrewDNAApp());
}

class BrewDNAApp extends StatelessWidget {
  const BrewDNAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (_) => getIt<AuthCubit>(),
          child: MaterialApp.router(
          title: 'BrewDNA',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: appRouter,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pl'),
            Locale('en'),
          ],
        ),
        );
      },
    );
  }
}
