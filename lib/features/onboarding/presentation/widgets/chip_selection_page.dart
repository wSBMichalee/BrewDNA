import 'package:flutter/cupertino.dart';
import 'package:hop_iq/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import 'dart:ui' as ui;

class ChipSelectionPage extends StatelessWidget {
  final int step;
  final int totalSteps;
  final String question;
  final String subtitle;
  final List<String> options;
  final Set<String> selectedValues;
  final ValueChanged<String> onToggle;
  final VoidCallback onNext;

  const ChipSelectionPage({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.question,
    required this.subtitle,
    required this.options,
    required this.selectedValues,
    required this.onToggle,
    required this.onNext,
  });

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
            question,
            style: AppTypography.title2.copyWith(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacings.s12),
          Text(
            subtitle,
            style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacings.s32),
          Expanded(
            child: options.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.exclamationmark_triangle, color: AppColors.separator, size: 48),
                        SizedBox(height: AppSpacings.s16),
                        Text(
                          'Brak dostępnych stylów piwa.',
                          style: AppTypography.body.copyWith(color: AppColors.labelSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.only(bottom: AppSpacings.s32),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3.0,
                    ),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final isSelected = selectedValues.contains(option);
                      return GestureDetector(
                        onTap: () => onToggle(option),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: AppSpacings.s8),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.accent : AppColors.background.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.accent
                                      : AppColors.separator.withValues(alpha: 0.5),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                option,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.body.copyWith(
                                  color: isSelected ? AppColors.white : AppColors.label,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SizedBox(height: AppSpacings.s16),
          AppButton(text: AppLocalizations.of(context)!.onboardingNextButton, onPressed: onNext),
          SizedBox(height: AppSpacings.s16),
        ],
      ),
    );
  }
}
