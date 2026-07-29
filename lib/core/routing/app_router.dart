import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:typed_data';
import '../../features/dev/presentation/screens/widget_gallery_screen.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/intro_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/hook_screen.dart';
import '../../features/auth/presentation/screens/email_screen.dart';
import '../../features/auth/presentation/screens/password_screen.dart';
import '../../features/auth/presentation/screens/details_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/auth_start_screen.dart';

import '../../features/paywall/presentation/screens/paywall_screen.dart';

import '../../features/main/presentation/screens/scan_screen.dart';
import '../../features/main/presentation/screens/history_screen.dart';
import '../../features/main/presentation/screens/map_screen.dart';
import '../../features/main/presentation/screens/discover_screen.dart';
import '../../features/main/presentation/screens/profile_screen.dart';
import '../../features/main/presentation/screens/scanning_analyzing_screen.dart';
import '../../features/beer/presentation/bloc/scan_cubit.dart';
import '../../features/beer/presentation/screens/beer_details_screen.dart';
import '../../features/beer/presentation/screens/beer_reviews_screen.dart';
import '../../features/beer/domain/entities/review.dart';
import '../../features/beer/domain/entities/rating_histogram.dart';
import 'main_shell.dart';
import '../theme/app_theme.dart';
import '../../core/di/injection.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/onboarding/presentation/bloc/onboarding_cubit.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _authShellNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _onboardingShellNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _mainShellNavigatorKey = GlobalKey<NavigatorState>();

class OnboardingShell extends StatelessWidget {
  final Widget child;
  const OnboardingShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OnboardingCubit>(),
      child: child,
    );
  }
}

class AuthShell extends StatelessWidget {
  final Widget child;
  const AuthShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final hideBack = location == '/' || location == '/onboarding/intro' || location == '/auth/welcome' || location == '/auth/start';

    return BlocProvider.value(
      value: getIt<AuthCubit>(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (!hideBack && context.canPop()) {
            context.pop();
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: hideBack
              ? null
              : AppBar(
                  backgroundColor: AppColors.background,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(CupertinoIcons.back, color: AppColors.label),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      }
                    },
                  ),
                ),
          body: child,
        ),
      ),
    );
  }
}


final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/main/discover',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/paywall',
      builder: (context, state) => PaywallScreen(),
    ),
    // Auth Flow Shell
    ShellRoute(
      navigatorKey: _authShellNavigatorKey,
      builder: (context, state, child) => AuthShell(child: child),
      routes: [
        ShellRoute(
          navigatorKey: _onboardingShellNavigatorKey,
          builder: (context, state, child) => OnboardingShell(child: child),
          routes: [
            GoRoute(
              path: '/onboarding/intro',
              builder: (context, state) => const IntroScreen(),
            ),
            GoRoute(
              path: '/onboarding/quiz',
              builder: (context, state) => const OnboardingScreen(),
            ),
            GoRoute(
              path: '/onboarding/hook',
              builder: (context, state) => const HookScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/auth/start',
          builder: (context, state) => AuthStartScreen(),
        ),

        GoRoute(
          path: '/auth/email',
          builder: (context, state) => AuthEmailScreen(),
        ),
        GoRoute(
          path: '/auth/password',
          builder: (context, state) => AuthPasswordScreen(),
        ),
        GoRoute(
          path: '/auth/details',
          builder: (context, state) => AuthDetailsScreen(),
        ),
        GoRoute(
          path: '/auth/welcome',
          builder: (context, state) => AuthWelcomeScreen(),
        ),
      ],
    ),
    // Main App Shell
    ShellRoute(
      navigatorKey: _mainShellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [

        GoRoute(
          path: '/main/history',
          pageBuilder: (context, state) => NoTransitionPage(child: HistoryScreen()),
        ),
        GoRoute(
          path: '/main/map',
          pageBuilder: (context, state) => NoTransitionPage(child: MapScreen()),
        ),
        GoRoute(
          path: '/main/discover',
          pageBuilder: (context, state) => NoTransitionPage(child: DiscoverScreen()),
        ),
        GoRoute(
          path: '/main/profile',
          pageBuilder: (context, state) => NoTransitionPage(child: ProfileScreen()),
        ),
      ],
    ),
    // Scan Flow (Full screen, no bottom bar)
    GoRoute(
      path: '/main/scan',
      builder: (context, state) => ScanScreen(),
    ),
    // Beer Details (Full screen, no bottom bar)
    GoRoute(
      path: '/main/beer/:id',
      builder: (context, state) => BeerDetailsScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/main/scanning',
      builder: (context, state) {
        final imageBytes = state.extra as List<int>;
        return BlocProvider(
          create: (context) => getIt<ScanCubit>(),
          child: ScanningAnalyzingScreen(imageBytes: Uint8List.fromList(imageBytes)),
        );
      },
    ),
    GoRoute(
      path: '/main/reviews',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return BeerReviewsScreen(
          beerId: extra['beerId'] as String,
          beerName: extra['beerName'] as String,
          histogram: extra['histogram'] as RatingHistogram,
          reviews: extra['reviews'] as List<Review>,
        );
      },
    ),
    GoRoute(
      path: '/_widget-gallery',
      builder: (context, state) => WidgetGalleryScreen(),
    ),
  ],
);
