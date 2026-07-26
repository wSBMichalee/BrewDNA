import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';

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
            'STEP $step OF $totalSteps',
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
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: options.map((option) {
                  final isSelected = selectedValues.contains(option);
                  return GestureDetector(
                    onTap: () => onToggle(option),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacings.s20,
                        vertical: AppSpacings.s12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.accent : AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.separator,
                          width: 1,
                        ),
                        boxShadow: isSelected
                            ? []
                            : [
                                BoxShadow(
                                  color: AppColors.black.withValues(alpha: 0.02),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: Text(
                        option,
                        style: AppTypography.body.copyWith(
                          color: isSelected ? AppColors.white : AppColors.label,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: AppSpacings.s16),
          AppButton(
            text: 'Dalej',
            onPressed: onNext,
          ),
          SizedBox(height: AppSpacings.s16),
        ],
      ),
    );
  }
}
