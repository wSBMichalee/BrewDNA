import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import 'dart:ui' as ui;

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/onboarding_cubit.dart';

class HookScreen extends StatefulWidget {
  const HookScreen({super.key});

  @override
  State<HookScreen> createState() => _HookScreenState();
}

class _HookScreenState extends State<HookScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final styleName = context.read<OnboardingCubit>().getRecommendedStyle();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          
          // Hero Image (Beer) with Animation
          ScaleTransition(
            scale: _scaleAnimation,
            child: CachedNetworkImage(
              imageUrl:
                  'https://media.screensdesign.com/gasset/e82346341291427ab997b8edb1aa3252_screen_image_ne_ipa_visual_8f69909d1e.png',
              height: 250,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: AppSpacings.s32),

          // Title
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              AppLocalizations.of(context)!.onboardingHookTitle, 
              style: AppTypography.brandDisplay.copyWith(color: AppColors.label),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: AppSpacings.s12),
          // Subtitle
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              AppLocalizations.of(context)!.onboardingHookSubtitle,
              style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: AppSpacings.s32),

          // Result Card with Glassmorphism and Animation
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
                  .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: AppSpacings.s24,
                      horizontal: AppSpacings.s24,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(
                        color: AppColors.separator.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          styleName,
                          style: AppTypography.title2.copyWith(color: AppColors.accent),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSpacings.s8),
                        Text(
                          AppLocalizations.of(context)!.onboardingHookDescription,
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: AppColors.labelSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacings.s16),

          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              AppLocalizations.of(context)!.onboardingHookFooter,
              style: AppTypography.body.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.labelSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          FadeTransition(
            opacity: _fadeAnimation,
            child: AppButton(
              text: AppLocalizations.of(context)!.onboardingHookRegisterButton,
              onPressed: () => context.go('/auth/start'),
            ),
          ),
          SizedBox(height: AppSpacings.s16),
        ],
      ),
    );
  }
}
