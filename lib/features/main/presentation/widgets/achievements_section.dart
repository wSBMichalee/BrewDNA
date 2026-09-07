import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../beer/presentation/bloc/beer_cubit.dart';
import '../../../beer/presentation/bloc/beer_state.dart';
import '../../../beer/domain/entities/beer.dart';
import '../../domain/entities/user_taste_stats.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BeerCubit, BeerState>(
      builder: (context, state) {
        final history = state.maybeWhen(
          loaded: (history, _, _, _, _, _, _) => history,
          orElse: () => <Beer>[],
        );
        
        if (history.isEmpty) {
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSpacings.s20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.separator.withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    children: [
                      Icon(CupertinoIcons.sparkles, color: AppColors.accent, size: 32),
                      SizedBox(height: AppSpacings.s12),
                      Text(
                        "Twoje osiągnięcia pojawią się tutaj",
                        style: AppTypography.subhead.copyWith(
                          color: AppColors.label,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacings.s4),
                      Text(
                        "Zeskanuj i oceń swoje pierwsze piwo, aby rozpocząć odkrywanie profilu!",
                        style: AppTypography.caption.copyWith(
                          color: AppColors.labelSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        final stats = UserTasteStats.fromHistory(history);

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
                    "${stats.uniqueStylesCount} odkrytych",
                  ),
                  SizedBox(width: AppSpacings.s16),
                  _buildAchievementCard(
                    context,
                    CupertinoIcons.rosette,
                    AppLocalizations.of(context)!.profileAchievement2Title,
                    "${stats.totalBeers} ocen",
                  ),
                ],
              ),
            ),
          ],
        );
      },
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
