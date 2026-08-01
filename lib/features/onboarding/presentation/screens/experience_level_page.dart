import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';

class ExperienceLevelPage extends StatelessWidget {
  final int step;
  final int totalSteps;
  final String? selectedLevel;
  final ValueChanged<String> onSelect;
  final VoidCallback onNext;

  const ExperienceLevelPage({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.selectedLevel,
    required this.onSelect,
    required this.onNext,
  });

  Widget _buildCard(String title, String subtitle, IconData icon) {
    final isSelected = selectedLevel == title;
    return GestureDetector(
      onTap: () => onSelect(title),
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacings.s16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: EdgeInsets.all(AppSpacings.s20),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accentTint : AppColors.background.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(
                  color: isSelected ? AppColors.accent : AppColors.separator.withValues(alpha: 0.5),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accent.withValues(alpha: 0.1) : AppColors.separator.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? AppColors.accent : AppColors.labelSecondary,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: AppSpacings.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: AppSpacings.s4),
                        Text(
                          subtitle,
                          style: AppTypography.subhead.copyWith(
                            color: AppColors.labelSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected) ...[
                    SizedBox(width: AppSpacings.s12),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CupertinoIcons.checkmark_alt,
                        color: AppColors.accent,
                        size: 16,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacings.s24),
      child: Column(
        children: [
          SizedBox(height: AppSpacings.s32),
          Text(
            AppLocalizations.of(context)!.onboardingStep(step.toString(), totalSteps.toString()),
            style: AppTypography.caption.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: AppSpacings.s16),
          Text(
            AppLocalizations.of(context)!.onboardingExpTitle,
            style: AppTypography.title2.copyWith(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacings.s32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCard(
                    AppLocalizations.of(context)!.onboardingExpLevel1Title,
                    AppLocalizations.of(context)!.onboardingExpLevel1Subtitle,
                    CupertinoIcons.book,
                  ),
                  _buildCard(
                    AppLocalizations.of(context)!.onboardingExpLevel2Title,
                    AppLocalizations.of(context)!.onboardingExpLevel2Subtitle,
                    CupertinoIcons.drop,
                  ),
                  _buildCard(
                    AppLocalizations.of(context)!.onboardingExpLevel3Title,
                    AppLocalizations.of(context)!.onboardingExpLevel3Subtitle,
                    CupertinoIcons.star,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSpacings.s16),
          AppButton(
            text: AppLocalizations.of(context)!.onboardingExpSeeProfileButton,
            onPressed: () {
              if (selectedLevel != null) onNext();
            },
          ),
          SizedBox(height: AppSpacings.s16),
        ],
      ),
    );
  }
}
