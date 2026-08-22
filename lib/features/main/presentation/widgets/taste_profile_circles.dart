import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/taste_profile.dart';

class TasteProfileCircles extends StatelessWidget {
  final bool isLoading;
  final TasteProfile? profile;
  final VoidCallback onEditTap;

  const TasteProfileCircles({
    super.key,
    required this.isLoading,
    this.profile,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }

    final currentProfile = profile ?? const TasteProfile(
      calculatedStrength: 50,
      calculatedBitterness: 50,
      calculatedFruitiness: 50,
    );

    return Container(
      padding: EdgeInsets.all(AppSpacings.s24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.separator.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.profileTasteProfileTitle,
                style: AppTypography.headline,
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onEditTap,
                child: const Icon(CupertinoIcons.pencil, color: AppColors.labelSecondary),
              ),
            ],
          ),
          SizedBox(height: AppSpacings.s24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTasteAxisCircle(
                context,
                title: _getBitternessLabel(context, currentProfile.effectiveBitterness),
                value: currentProfile.effectiveBitterness,
                color: const Color(0xFF6A994E),
                icon: CupertinoIcons.leaf_arrow_circlepath,
              ),
              _buildTasteAxisCircle(
                context,
                title: _getStrengthLabel(context, currentProfile.effectiveStrength),
                value: currentProfile.effectiveStrength,
                color: const Color(0xFFBC4749),
                icon: CupertinoIcons.bolt_fill,
              ),
              _buildTasteAxisCircle(
                context,
                title: _getFruitinessLabel(context, currentProfile.effectiveFruitiness),
                value: currentProfile.effectiveFruitiness,
                color: const Color(0xFFF2A65A),
                icon: CupertinoIcons.drop_fill,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getBitternessLabel(BuildContext context, double value) {
    if (value < 34) return AppLocalizations.of(context)!.onboardingQ1Left;
    if (value > 66) return AppLocalizations.of(context)!.onboardingQ1Right;
    return AppLocalizations.of(context)!.tasteProfileBalanced;
  }

  String _getStrengthLabel(BuildContext context, double value) {
    if (value < 34) return AppLocalizations.of(context)!.onboardingQ2Left;
    if (value > 66) return AppLocalizations.of(context)!.onboardingQ2Right;
    return AppLocalizations.of(context)!.tasteProfileBalanced;
  }

  String _getFruitinessLabel(BuildContext context, double value) {
    if (value < 34) return AppLocalizations.of(context)!.onboardingQ3Left;
    if (value > 66) return AppLocalizations.of(context)!.onboardingQ3Right;
    return AppLocalizations.of(context)!.tasteProfileBalanced;
  }

  Widget _buildTasteAxisCircle(
    BuildContext context, {
    required String title,
    required double value,
    required Color color,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onEditTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: AppSpacings.s8),
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: value / 100,
                  strokeWidth: 8,
                  backgroundColor: AppColors.separator.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Text(
                    '${value.round()}%',
                    style: AppTypography.headline.copyWith(
                      color: AppColors.label,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacings.s8),
          Text(
            title,
            style: AppTypography.caption.copyWith(
              color: AppColors.labelSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
