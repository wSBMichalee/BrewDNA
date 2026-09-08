import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';

class AuthWelcomeScreen extends StatelessWidget {
  const AuthWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final displayName = state.name.isNotEmpty ? state.name : 'Piwoszu';
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              // Hero Image with Gradient
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/auth_hero.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.accentTint,
                        child: const Icon(CupertinoIcons.sparkles, size: 48),
                      ),
                    ),
                    // Gradient overlay to blend with background
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.background.withValues(alpha: 0.0),
                              AppColors.background,
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.welcomeTitle(displayName),
                        style: AppTypography.pageHeadline,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacings.s16),
                      Text(
                        AppLocalizations.of(context)!.welcomeSubtitle,
                        style: AppTypography.body.copyWith(
                          color: AppColors.labelSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacings.s12),
                      const Icon(
                        CupertinoIcons.sparkles,
                        color: AppColors.accent,
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          text: AppLocalizations.of(context)!.welcomeScanButton,
                          onPressed: () => context.go('/main/scan'),
                        ),
                      ),
                      SizedBox(height: AppSpacings.s16),
                      CupertinoButton(
                        onPressed: () => context.go('/main/discover'),
                        child: Text(
                          AppLocalizations.of(context)!.welcomeMaybeLater,
                          style: AppTypography.body.copyWith(
                            color: AppColors.labelSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacings.s32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
