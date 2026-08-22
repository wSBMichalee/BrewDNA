import 'package:flutter/cupertino.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
          child: Text(
            AppLocalizations.of(context)!.profileAchievementsTitle,
            style: AppTypography.title2,
          ),
        ),
        SizedBox(height: AppSpacings.s16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
          child: Row(
            children: [
              _buildAchievementCard(
                context,
                CupertinoIcons.leaf_arrow_circlepath,
                AppLocalizations.of(context)!.profileAchievement1Title,
                AppLocalizations.of(context)!.profileAchievement1Subtitle,
              ),
              SizedBox(width: AppSpacings.s16),
              _buildAchievementCard(
                context,
                CupertinoIcons.rosette,
                AppLocalizations.of(context)!.profileAchievement2Title,
                AppLocalizations.of(context)!.profileAchievement2Subtitle,
              ),
              SizedBox(width: AppSpacings.s16),
              _buildAchievementCard(
                context,
                CupertinoIcons.star,
                AppLocalizations.of(context)!.profileAchievement3Title,
                AppLocalizations.of(context)!.profileAchievement3Subtitle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(BuildContext context, IconData icon, String title, String subtitle) {
    return SizedBox(
      width: 144,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacings.s12,
          vertical: AppSpacings.s20,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.separator.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.accent, size: 32),
            SizedBox(height: AppSpacings.s12),
            Text(
              title,
              style: AppTypography.subhead.copyWith(
                color: AppColors.label,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: AppSpacings.s4),
            Text(
              subtitle,
              style: AppTypography.caption.copyWith(
                color: AppColors.labelSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
