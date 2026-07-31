import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hop_iq/l10n/app_localizations.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/onboarding_cubit.dart';

class HookScreen extends StatelessWidget {
  const HookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final styleName = context.read<OnboardingCubit>().getRecommendedStyle();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Badge
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.accentTint,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                CupertinoIcons.checkmark_alt,
                color: AppColors.accent,
                size: 32,
              ),
            ),
          ),
          SizedBox(height: AppSpacings.s24),
          Text(AppLocalizations.of(context)!.onboardingHookTitle, style: AppTypography.title2.copyWith(fontSize: 28)),
          SizedBox(height: AppSpacings.s12),
          Text(
            AppLocalizations.of(context)!.onboardingHookSubtitle,
            style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacings.s32),

          // Result Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: AppSpacings.s32,
              horizontal: AppSpacings.s24,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: AppColors.accentTint,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://media.screensdesign.com/gasset/e82346341291427ab997b8edb1aa3252_screen_image_ne_ipa_visual_8f69909d1e.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacings.s24),
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
          SizedBox(height: AppSpacings.s32),

          Text(
            AppLocalizations.of(context)!.onboardingHookFooter,
            style: AppTypography.body.copyWith(
              fontStyle: FontStyle.italic,
              color: AppColors.labelSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          AppButton(
            text: AppLocalizations.of(context)!.onboardingHookRegisterButton,
            onPressed: () => context.go('/auth/start'),
          ),
          SizedBox(height: AppSpacings.s16),
        ],
      ),
    );
  }
}
