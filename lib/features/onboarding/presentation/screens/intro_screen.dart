import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_icons.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/onboarding_cubit.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<OnboardingCubit>().reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Background Image with Gradient Overlay
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRect(
                  child: Image.asset(
                    'assets/images/onboarding_light_beer.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.accentTint,
                      child: const Center(
                        child: Icon(
                          Icons.local_drink,
                          color: AppColors.accent,
                          size: 64,
                        ),
                      ),
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.05, 1.05),
                    duration: 15.seconds,
                    curve: Curves.easeInOut,
                  ),
                ),
                // Gradient to fade into background
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 120,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.background.withValues(alpha: 0.0),
                          AppColors.background,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Foreground Content
          SafeArea(
            top: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // First group of animations (header, subtitle, features)
                ...[
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.gold, AppColors.accent, AppColors.accentDeep],
                    ).createShader(bounds),
                    child: Text(
                      'BrewDNA',
                      style: AppTypography.pageHeadline.copyWith(color: AppColors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: AppSpacings.s8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacings.s32),
                    child: Text(
                      AppLocalizations.of(context)!.onboardingIntroSubtitle,
                      style: AppTypography.body.copyWith(
                        color: AppColors.labelSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: AppSpacings.s32),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacings.s32),
                    child: Column(
                      children: [
                        _buildFeatureItem(
                          icon: CupertinoIcons.viewfinder,
                          title: AppLocalizations.of(context)!.onboardingIntroFeature1Title,
                          description: AppLocalizations.of(context)!.onboardingIntroFeature1Desc,
                        ),
                        SizedBox(height: AppSpacings.s24),
                        _buildFeatureItem(
                          customIcon: SizedBox(
                            width: 20,
                            height: 20,
                            child: CustomPaint(
                              painter: DnaHelixPainter(color: AppColors.accent),
                            ),
                          ),
                          title: AppLocalizations.of(context)!.onboardingIntroFeature2Title,
                          description: AppLocalizations.of(context)!.onboardingIntroFeature2Desc,
                        ),
                      ],
                    ),
                  ),
                ]
                .animate(interval: 100.ms)
                .fade(duration: 600.ms, curve: Curves.easeOutCubic)
                .slideY(begin: 0.1, end: 0, duration: 600.ms, curve: Curves.easeOutCubic),

                SizedBox(height: 24.h),

                // Second group of animations (buttons)
                ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                    child: AppButton(
                      text: AppLocalizations.of(context)!.onboardingIntroStartButton,
                      onPressed: () => context.go('/onboarding/quiz'),
                    )
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .scale(
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1.02, 1.02),
                      duration: 2.seconds,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  SizedBox(height: AppSpacings.s8),
                  _AnimatedLoginButton(
                    text: AppLocalizations.of(context)!.onboardingIntroLoginButton,
                    onTap: () => context.push('/auth/login'),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom + AppSpacings.s16,
                  ),
                ]
                .animate(interval: 100.ms, delay: 500.ms)
                .fade(duration: 600.ms, curve: Curves.easeOutCubic)
                .slideY(begin: 0.1, end: 0, duration: 600.ms, curve: Curves.easeOutCubic),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    IconData? icon,
    Widget? customIcon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.accentTint,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: customIcon ?? Icon(icon!, color: AppColors.accent, size: 20),
          ),
        ),
        SizedBox(width: AppSpacings.s16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.headline.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTypography.caption.copyWith(
                  color: AppColors.labelSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnimatedLoginButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;

  const _AnimatedLoginButton({required this.onTap, required this.text});

  @override
  State<_AnimatedLoginButton> createState() => _AnimatedLoginButtonState();
}

class _AnimatedLoginButtonState extends State<_AnimatedLoginButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: 150.ms,
        curve: Curves.easeOutCubic,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacings.s12,
            horizontal: AppSpacings.s24,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                style: AppTypography.body.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                CupertinoIcons.chevron_right,
                size: 16,
                color: AppColors.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
